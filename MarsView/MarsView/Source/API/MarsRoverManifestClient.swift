//
//  MarsRoverClient.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
//
//  MarsRoverManifestClient.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

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
                seal.fulfill(manifest)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                seal.reject(MarsRoverClientError.decodingError)
            }
        }
        
        return promise
    }
}
