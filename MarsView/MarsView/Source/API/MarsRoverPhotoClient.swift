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
                seal.fulfill(photos)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                seal.reject(MarsRoverClientError.decodingError)
            }
        }
        
        return promise
    }
    
    private func buildPhotoURL(using roverName: String, sol: Int, camera: String) -> String {
        return baseApiURL + Constants.URLs.PhotosBaseURL + roverName.lowercased() + "/" + Constants.Keys.photosKey + "?" + Constants.Keys.solKey + "=\(sol)&" + Constants.Keys.cameraKey + "=\(camera.lowercased())&" + apiKey
    }
}
