//
//  MarsRoverPhotoClient.swift
//  MarsView
//
//  Created by Christian Henne on 4/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import CoreData

// MARK: - Client Prototype
// Uses prototype to make for easier unit testing via injection

protocol MarsRoverPhotoClientType: MarsRoverBaseDataClient {
    func getRoverPhotos(using roverName: String, sol: Int, camera: String) -> Promise<RoverPhotos>
}

class MarsRoverPhotoClient: MarsRoverPhotoClientType {
    
    // MARK: - Constants
    
    struct Constants {
        struct Keys {
            static let solKey = "sol"
            static let cameraKey = "camera"
            static let photosKey = "photos"
        }
        
        struct URLs {
            static let PhotosBaseURL = "rovers/"
        }
    }
    
    // MARK: - MarsRoverDataClientType Functions
    func getRoverPhotos(using roverName: String, sol: Int, camera: String) -> Promise<RoverPhotos> {
        if !Reachability.isConnectedToNetwork() {
            return getRoverPhotosUsingWeb(using: roverName, sol: sol, camera: camera)
        } else {
            return getRoverPhotosUsingCoreData(using: roverName, sol: sol, camera: camera)
        }
    }
    
    private func getRoverPhotosUsingWeb(using roverName: String, sol: Int, camera: String) -> Promise<RoverPhotos> {
        
        let urlString = buildPhotoURL(using: roverName, sol: sol, camera: camera)
        guard let url = URL(string: urlString) else { return Promise<RoverPhotos>.init(error: MarsRoverClientError.unknownError) }
        
        let (promise, seal) = Promise<RoverPhotos>.pending()
        
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
                let photos = try jsonDecoder.decode(RoverPhotos.self, from: value)
                self.savePhotos(photos, using: roverName, sol: sol, camera: camera)
                seal.fulfill(photos)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                seal.reject(MarsRoverClientError.decodingError)
            }
        }
        
        return promise
    }
    
    private func getRoverPhotosUsingCoreData(using roverName: String, sol: Int, camera: String) -> Promise<RoverPhotos> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return Promise<RoverPhotos>.init(error: MarsRoverClientError.unknownError)
        }
        
        let urlString = buildPhotoURL(using: roverName, sol: sol, camera: camera)
        
        let (promise, seal) = Promise<RoverPhotos>.pending()
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RoverPhotosEntity")
        fetchRequest.predicate = NSPredicate(format:"url=%@", urlString)
        
        do {
            let photosEntities = try managedContext.fetch(fetchRequest)
            if let entity = photosEntities.first as? RoverPhotosEntity {
                let photos = RoverPhotos(from: entity)
                seal.fulfill(photos)
            }
        } catch {
            let photos = RoverPhotos(photos: [])
            seal.fulfill(photos)
        }
        
        return promise
    }
    
    private func savePhotos(_ photos: RoverPhotos, using roverName: String, sol: Int, camera: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let urlString = buildPhotoURL(using: roverName, sol: sol, camera: camera)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RoverPhotosEntity")
        fetchRequest.predicate = NSPredicate(format:"url=%@", urlString)
        
        var photosEntity: RoverPhotosEntity?
        do {
            let photosEntities = try? managedContext.fetch(fetchRequest)
            if let entity = photosEntities?.first as? RoverPhotosEntity {
                photosEntity = entity
            }
        }
        
        if photosEntity == nil {
            photosEntity = RoverPhotosEntity(context: managedContext)
        }
        
        photos.encode(to: photosEntity!, using: managedContext)
        photosEntity!.url = urlString
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func buildPhotoURL(using roverName: String, sol: Int, camera: String) -> String {
        return baseApiURL + Constants.URLs.PhotosBaseURL + roverName.lowercased() + "/" + Constants.Keys.photosKey + "?" + Constants.Keys.solKey + "=\(sol)&" + Constants.Keys.cameraKey + "=\(camera.lowercased())&" + apiKey
    }
}
