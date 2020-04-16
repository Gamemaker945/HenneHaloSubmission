//
//  MarsRoverClient.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Client Error Type

enum MarsRoverClientError: Error {
    
    case serverError
    case wrongMimeType
    case decodingError
    case unknownError
    
    public var localizedDescription: String {
        switch self {
        case .serverError, .unknownError:
            return NSLocalizedString("There was an error at the server. Please try again later.", comment: "Fetch Error")
        case .wrongMimeType, .decodingError:
            return NSLocalizedString("There was an issue with the data returned. Please try again later.", comment: "Fetch Error")
        }
    }
}

// MARK: - Client Prototype
// Uses prototype to make for easier unit testing via injection

protocol MarsRoverDataClientType {
    func getRoverManifest(using rover: RoverModel, onComplete: @escaping ((_ roverManifest: RoverPhotoManifest?, _ error: MarsRoverClientError?) -> Void))
    func getRoverPhotos(using roverName: String, sol: Int, camera: String, onComplete: @escaping ((_ roverPhotos: RoverPhotos?, _ error: MarsRoverClientError?) -> Void))
}

class MarsRoverDataClient: MarsRoverDataClientType {
    
    // MARK: - Constants
    
    struct Constants {
        struct Keys {
            static let API_KEY = "api_key=oRuTcpFkyrrXlxdfRw9IxweaVMBIwt4ZOfvfZoZC"
            static let solKey = "sol"
            static let cameraKey = "camera"
            static let photosKey = "photos"
        }
        
        struct URLs {
            static let ManifestBaseURL = "https://api.nasa.gov/mars-photos/api/v1/manifests/"
            static let PhotosBaseURL = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
        }
    }
    
    // MARK: - MarsRoverDataClientType Functions
    
    func getRoverManifest(using rover: RoverModel, onComplete: @escaping ((_ roverManifest: RoverPhotoManifest?, _ error: MarsRoverClientError?) -> Void)) {
        
        let urlString = Constants.URLs.ManifestBaseURL + rover.name.lowercased() + "?" + Constants.Keys.API_KEY
        guard let url = URL(string: urlString) else { return }
        
        Alamofire.request(url).responseData { response in
            guard response.result.isSuccess else {
                onComplete(nil, MarsRoverClientError.serverError)
                return
            }
            
            guard let value = response.result.value else {
                onComplete(nil, MarsRoverClientError.serverError)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let manifest = try jsonDecoder.decode(RoverPhotoManifest.self, from: value)
                onComplete(manifest, nil)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                onComplete(nil, MarsRoverClientError.decodingError)
            }
        }
    }
    
    func getRoverPhotos(using roverName: String, sol: Int, camera: String, onComplete: @escaping ((_ roverPhotos: RoverPhotos?, _ error: MarsRoverClientError?) -> Void)) {
        
        let urlString = Constants.URLs.PhotosBaseURL + roverName.lowercased() + "/" + Constants.Keys.photosKey + "?" + Constants.Keys.solKey + "=\(sol)&" + Constants.Keys.cameraKey + "=\(camera.lowercased())&" + Constants.Keys.API_KEY
        guard let url = URL(string: urlString) else { return }
        
        Alamofire.request(url).responseData { response in
            guard response.result.isSuccess else {
                onComplete(nil, MarsRoverClientError.serverError)
                return
            }
            
            guard let value = response.result.value else {
                onComplete(nil, MarsRoverClientError.serverError)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let photos = try jsonDecoder.decode(RoverPhotos.self, from: value)
                onComplete(photos, nil)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                onComplete(nil, MarsRoverClientError.decodingError)
            }
        }
    }
}
