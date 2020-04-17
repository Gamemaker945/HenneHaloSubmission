//
//  MarsRoverPhotoClientMock.swift
//  MarsViewTests
//
//  Created by Christian Henne on 4/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import PromiseKit

@testable import MarsView

class MarsRoverPhotoClientMock: MarsRoverPhotoClientType {
    
    var hasError: Bool = false
    
    func getRoverPhotos(using roverName: String, sol: Int, camera: String) -> Promise<RoverPhotos> {
        if hasError {
            return Promise<RoverPhotos>.init(error: MarsRoverClientError.serverError)
        } else {
            return Promise<RoverPhotos>.value(createTestData())
        }
    }
    
    func createTestData() -> RoverPhotos {
        
        let camera = RoverCamera(id: 1, name: "CAM", roverID: 1, fullName: "Camera 1")
        let photo = RoverPhoto(id: 1, sol: 1, camera: camera, imgSrc: "http://www.google.com", earthDate: "01-02-2020")
        let photos = RoverPhotos(photos: [photo])
        return photos
    }
}
