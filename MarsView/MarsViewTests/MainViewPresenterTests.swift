//
//  MainViewPresenterTests.swift
//  MarsViewTests
//
//  Created by Christian Henne on 4/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import XCTest
@testable import MarsView

class MainViewPresenterTests: XCTestCase {

    var manifestClient: MarsRoverManifestClientMock!
    var photoClient: MarsRoverPhotoClientMock!
    var roverDataService: MarsRoverDataServiceType!
    var view: MainViewMock!
    var subject: MainViewPresenterType!
    
    override func setUpWithError() throws {
        manifestClient = MarsRoverManifestClientMock()
        photoClient = MarsRoverPhotoClientMock()
        roverDataService = MarsRoverDataService(manifestClient: manifestClient, photoClient: photoClient)
        view = MainViewMock()
        
        subject = MainViewPresenter(view: view, marsRoverDataService: roverDataService)
    }

    func test_ViewDidLoad_NoRoverManifest() {
        let rover = RoverModel(name: "Test")
        subject.viewDidLoad(rover: rover)
        wait(for: 1)
        
        XCTAssertNotNil(view.viewModel)
        XCTAssertTrue(view.loadingShown)
        XCTAssertTrue(view.loadingHidden)
        XCTAssertFalse(view.errorShown)
    }
    
    func test_ViewDidLoad_CachedRoverManifest() {
        let rover = RoverModel(name: "Test")
        rover.manifest = RoverManifest(name: "Test Rover", landingDate: "02-02-2020", launchDate: "01-02-2020", status: "Completed", maxSol: 100, maxDate: "03-02-2020", totalPhotos: 100, sols: [])
        subject.viewDidLoad(rover: rover)
        wait(for: 1)
        
        XCTAssertNotNil(view.viewModel)
        XCTAssertFalse(view.loadingShown)
        XCTAssertFalse(view.loadingHidden)
        XCTAssertFalse(view.errorShown)
    }
    
    func test_ViewDidLoad_WithError() {
        manifestClient.hasError = true
        let rover = RoverModel(name: "Test")
        subject.viewDidLoad(rover: rover)
        wait(for: 1)
        
        XCTAssertNil(view.viewModel)
        XCTAssertTrue(view.loadingShown)
        XCTAssertTrue(view.loadingHidden)
        XCTAssertTrue(view.errorShown)
    }
    
    func test_RoverSelected_FirstFetch_NoManifestCached() {
        let rover = RoverModel(name: "Test")
        subject.roverSelected(rover)
        wait(for: 1)
        
        XCTAssertNotNil(view.viewModel)
        XCTAssertTrue(view.loadingShown)
        XCTAssertTrue(view.loadingHidden)
        XCTAssertFalse(view.errorShown)
    }
    
    func test_RoverSelected_SecondFetch_ManifestCached() {
        let rover = RoverModel(name: "Test")
        rover.manifest = RoverManifest(name: "Test Rover", landingDate: "02-02-2020", launchDate: "01-02-2020", status: "Completed", maxSol: 100, maxDate: "03-02-2020", totalPhotos: 100, sols: [])
        subject.roverSelected(rover)
        wait(for: 1)
        
        XCTAssertNotNil(view.viewModel)
        XCTAssertFalse(view.loadingShown)
        XCTAssertFalse(view.loadingHidden)
        XCTAssertFalse(view.errorShown)
    }
}

class MainViewMock: MainViewType {
    var viewModel: MainViewModel?
    var errorShown = false
    var loadingShown = false
    var loadingHidden = false
    
    func showLoading() { loadingShown = true }
    func hideLoading() { loadingHidden = true }
    
    func showError(_ error: Error) {
        errorShown = true
    }
}

extension XCTestCase {

  func wait(for duration: TimeInterval) {
    let waitExpectation = expectation(description: "Waiting")

    let when = DispatchTime.now() + duration
    DispatchQueue.main.asyncAfter(deadline: when) {
      waitExpectation.fulfill()
    }

    // We use a buffer here to avoid flakiness with Timer on CI
    waitForExpectations(timeout: duration + 0.5)
  }
}
