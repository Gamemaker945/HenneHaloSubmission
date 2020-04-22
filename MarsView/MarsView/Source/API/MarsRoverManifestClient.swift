//
//  MarsRoverClient.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.

import Foundation
import Alamofire
import PromiseKit
import CoreData

// MARK: - Client Prototype
// Uses prototype to make for easier unit testing via injection

protocol MarsRoverManifestClientType: MarsRoverBaseDataClient {
    func getRoverManifest(using rover: RoverModel) -> Promise<RoverPhotoManifest>
}

class MarsRoverManifestClient: MarsRoverManifestClientType {
    
    // MARK: - Constants
    
    struct Constants {
        struct Keys {
            static let solKey = "sol"
            static let cameraKey = "camera"
            static let photosKey = "photos"
        }
        
        struct URLs {
            static let ManifestBaseURL = "manifests/"
            static let PhotosBaseURL = "rovers/"
        }
    }
    
    // MARK: - MarsRoverDataClientType Functions
    func getRoverManifest(using rover: RoverModel) -> Promise<RoverPhotoManifest> {
        if Reachability.isConnectedToNetwork() {
            return getRoverManifestFromWeb(using: rover)
        } else {
            return getRoverManifestFromCoreData(using: rover)
        }
    }
    
    
    private func getRoverManifestFromWeb(using rover: RoverModel) -> Promise<RoverPhotoManifest> {
        
        let urlString = baseApiURL + Constants.URLs.ManifestBaseURL + rover.name.lowercased() + "?" + apiKey
        guard let url = URL(string: urlString) else {
            return Promise<RoverPhotoManifest>.init(error: MarsRoverClientError.unknownError)
        }
        
        let (promise, seal) = Promise<RoverPhotoManifest>.pending()

        Alamofire.request(url).responseData { response in
            guard response.result.isSuccess else {
                seal.reject(MarsRoverClientError.serverError)
                return
            }
            
            guard let value = response.result.value else {
                seal.reject(MarsRoverClientError.serverError)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let manifest = try jsonDecoder.decode(RoverPhotoManifest.self, from: value)
                self.saveManifest(manifest.photo_manifest, for: rover)
                seal.fulfill(manifest)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                seal.reject(MarsRoverClientError.decodingError)
            }
        }
        
        return promise
    }
    
    private func getRoverManifestFromCoreData(using rover: RoverModel) -> Promise<RoverPhotoManifest> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return Promise<RoverPhotoManifest>.init(error: MarsRoverClientError.unknownError)
        }
        
        let (promise, seal) = Promise<RoverPhotoManifest>.pending()
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RoverManifestEntity")
        fetchRequest.predicate = NSPredicate(format:"name=%@", rover.name)
        
        do {
            let manifestEntities = try managedContext.fetch(fetchRequest)
            if let entity = manifestEntities.first as? RoverManifestEntity {
                let manifest = RoverManifest(from: entity)
                seal.fulfill(RoverPhotoManifest(photo_manifest: manifest))
            }
        } catch {
            seal.reject(MarsRoverClientError.decodingError)
        }
        
        return promise
    }
    
    private func saveManifest(_ manifest: RoverManifest, for rover: RoverModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RoverManifestEntity")
        fetchRequest.predicate = NSPredicate(format:"name=%@", rover.name)
        
        var manifestEntity: RoverManifestEntity?
        do {
            let manifestEntities = try? managedContext.fetch(fetchRequest)
            if let entity = manifestEntities?.first as? RoverManifestEntity {
                manifestEntity = entity
            }
        }
        
        if manifestEntity == nil {
            manifestEntity = RoverManifestEntity(context: managedContext)
        }
        manifest.encode(to: manifestEntity!, using: managedContext)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
