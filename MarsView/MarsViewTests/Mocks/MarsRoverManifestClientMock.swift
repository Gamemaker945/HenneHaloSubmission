//
//  MarsRoverManifestClientMock.swift
//  MarsViewTests
//
//  Created by Christian Henne on 4/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import PromiseKit

@testable import MarsView

class MarsRoverManifestClientMock: MarsRoverManifestClientType {
    
    var hasError: Bool = false 
    
    func getRoverManifest(using rover: RoverModel) -> Promise<RoverPhotoManifest> {
        if hasError {
            return Promise<RoverPhotoManifest>.init(error: MarsRoverClientError.serverError)
        } else {
            return Promise<RoverPhotoManifest>.value(createTestData())
        }
    }
    
    func createTestData() -> RoverPhotoManifest {
        
        let sol = RoverManifestPhotoSol(sol: 0, earthDate: "01-02-2020", totalPhotos: 10, cameras: ["CAM"])
        let manifest = RoverManifest(name: "Test Rover", landingDate: "02-02-2020", launchDate: "01-02-2020", status: "Completed", maxSol: 100, maxDate: "03-02-2020", totalPhotos: 100, sols: [sol])
        let photoManifest = RoverPhotoManifest(photo_manifest: manifest)
        return photoManifest
    }
}
