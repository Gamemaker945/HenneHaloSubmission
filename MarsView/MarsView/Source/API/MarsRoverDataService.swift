//
//  MarsRoverDataService.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

// MARK: - Service Prototype
// Uses prototype to make for easier unit testing via injection

protocol MarsRoverDataServiceType {
    func getRoverManifest(using rover: RoverModel, onComplete: @escaping ((_ roverManifest: RoverPhotoManifest?, _ error: Error?) -> Void))
    func getRoverPhotos(using roverName: String, sol: Int, camera: String, onComplete: @escaping ((_ roverPhotos: RoverPhotos?, _ error: Error?) -> Void))
}


class MarsRoverDataService: MarsRoverDataServiceType {
    
    let dataClient: MarsRoverDataClientType
    
    // Inject client into service for easy unit testing
    init(roverDataClient: MarsRoverDataClientType) {
        self.dataClient = roverDataClient
    }
    
    func getRoverManifest(using rover: RoverModel, onComplete: @escaping ((_ roverManifest: RoverPhotoManifest?, _ error: Error?) -> Void)) {
        dataClient.getRoverManifest(using: rover, onComplete: onComplete)
    }
    
    func getRoverPhotos(using roverName: String, sol: Int, camera: String, onComplete: @escaping ((_ roverPhotos: RoverPhotos?, _ error: Error?) -> Void)) {
        dataClient.getRoverPhotos(using: roverName, sol: sol, camera: camera, onComplete: onComplete)
    }
    
}
