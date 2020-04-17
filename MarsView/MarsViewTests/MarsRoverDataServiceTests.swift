//
//  MarsRoverDataServiceTests.swift
//  MarsViewTests
//
//  Created by Christian Henne on 4/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import XCTest
@testable import MarsView

class MarsRoverDataServiceTests: XCTestCase {

    var manifestClient: MarsRoverManifestClientMock!
    var photoClient: MarsRoverPhotoClientMock!
    var subject: MarsRoverDataServiceType!
    
    override func setUpWithError() throws {
        manifestClient = MarsRoverManifestClientMock()
        photoClient = MarsRoverPhotoClientMock()
        
        subject = MarsRoverDataService(manifestClient: manifestClient, photoClient: photoClient)
    }

    func test_ManifestFetch_Success() throws {
        let fetchCompletedExpectation = expectation(description: "Fetch Completed")
        let roverModel = RoverModel(name: "Test")
        
        var manifestResult: RoverPhotoManifest?
        subject.getRoverManifest(using: roverModel).done { manifest in
            manifestResult = manifest
            fetchCompletedExpectation.fulfill()
        }.catch { error in
            XCTFail("Test completed with unexpected error - " + error.localizedDescription)
        }
        
        wait(for: [fetchCompletedExpectation], timeout: 1)
        XCTAssertNotNil(manifestResult)
    }
    
    func test_ManifestFetch_Failure() throws {
        let fetchCompletedExpectation = expectation(description: "Fetch Completed")
        let roverModel = RoverModel(name: "Test")
        
        manifestClient.hasError = true
        var manifestResult: RoverPhotoManifest?
        subject.getRoverManifest(using: roverModel).done { manifest in
            manifestResult = manifest
            XCTFail("Test completed with unexpected result")
        }.catch { error in
            fetchCompletedExpectation.fulfill()
        }
        
        wait(for: [fetchCompletedExpectation], timeout: 1)
        XCTAssertNil(manifestResult)
    }
    
    func test_PhotoFetch_Success() throws {
        let fetchCompletedExpectation = expectation(description: "Fetch Completed")
        
        var photosResult: RoverPhotos?
        subject.getRoverPhotos(using: "Test", sol: 0, camera: "CAM").done { photos in
            photosResult = photos
            fetchCompletedExpectation.fulfill()
        }.catch { error in
            XCTFail("Test completed with unexpected error - " + error.localizedDescription)
        }
        
        wait(for: [fetchCompletedExpectation], timeout: 1)
        XCTAssertNotNil(photosResult)
    }
    
    func test_PhotoFetch_Failure() throws {
        let fetchCompletedExpectation = expectation(description: "Fetch Completed")
        
        photoClient.hasError = true
        var photosResult: RoverPhotos?
        subject.getRoverPhotos(using: "Test", sol: 0, camera: "CAM").done { photos in
            photosResult = photos
            XCTFail("Test completed with unexpected result")
        }.catch { error in
            fetchCompletedExpectation.fulfill()
        }
        
        wait(for: [fetchCompletedExpectation], timeout: 1)
        XCTAssertNil(photosResult)
    }
}
