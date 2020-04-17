//
//  PhotoViewPresenterUnitTests.swift
//  MarsViewTests
//
//  Created by Christian Henne on 4/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import XCTest
@testable import MarsView

class PhotoViewPresenterUnitTests: XCTestCase {

    var manifestClient: MarsRoverManifestClientMock!
    var photoClient: MarsRoverPhotoClientMock!
    var roverDataService: MarsRoverDataServiceType!
    var view: PhotoViewMock!
    var subject: PhotoViewPresenterType!
    
    override func setUpWithError() throws {
        manifestClient = MarsRoverManifestClientMock()
        photoClient = MarsRoverPhotoClientMock()
        roverDataService = MarsRoverDataService(manifestClient: manifestClient, photoClient: photoClient)
        view = PhotoViewMock()
        
        subject = PhotoViewPresenter(view: view, roverName: "Test", solIndex: 1, camera: "CAM", marsRoverDataService: roverDataService)
    }

    func test_ViewDidLoad() {
        subject.viewDidLoad()
        wait(for: 1)
        
        XCTAssertNotNil(view.viewModel)
        XCTAssertTrue(view.loadingShown)
        XCTAssertTrue(view.loadingHidden)
        XCTAssertFalse(view.errorShown)
    }
    
    func test_ViewDidLoad_WithError() {
        photoClient.hasError = true
        subject.viewDidLoad()
        wait(for: 1)
        
        XCTAssertNil(view.viewModel)
        XCTAssertTrue(view.loadingShown)
        XCTAssertTrue(view.loadingHidden)
        XCTAssertTrue(view.errorShown)
    }
}

class PhotoViewMock: PhotoViewType {
    var viewModel: PhotoViewModel?
    var errorShown = false
    var loadingShown = false
    var loadingHidden = false
    
    func showLoading() { loadingShown = true }
    func hideLoading() { loadingHidden = true }
    
    func showError(_ error: Error) {
        errorShown = true
    }
}
