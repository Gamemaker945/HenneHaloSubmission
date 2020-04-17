//
//  MarsRoverDataService.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import PromiseKit

// MARK: - Service Prototype
// Uses prototype to make for easier unit testing via injection

protocol MarsRoverDataServiceType {
    func getRoverManifest(using rover: RoverModel) -> Promise<RoverPhotoManifest>
    func getRoverPhotos(using roverName: String, sol: Int, camera: String)  -> Promise<RoverPhotos>
}


class MarsRoverDataService: MarsRoverDataServiceType {
    
    let manifestClient: MarsRoverManifestClientType
    let photoClient: MarsRoverPhotoClientType
    
    // Inject client into service for easy unit testing
    init(manifestClient: MarsRoverManifestClientType, photoClient: MarsRoverPhotoClientType) {
        self.manifestClient = manifestClient
        self.photoClient = photoClient
    }
    
    func getRoverManifest(using rover: RoverModel) -> Promise<RoverPhotoManifest> {
        return manifestClient.getRoverManifest(using: rover)
    }
    
    func getRoverPhotos(using roverName: String, sol: Int, camera: String)  -> Promise<RoverPhotos> {
        return photoClient.getRoverPhotos(using: roverName, sol: sol, camera: camera)
    }
    
}
