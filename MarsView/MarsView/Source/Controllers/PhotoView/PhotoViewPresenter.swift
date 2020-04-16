//
//  PhotoViewPresenter.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

protocol PhotoViewPresenterType {
    
    func viewDidLoad()

}

final class PhotoViewPresenter: PhotoViewPresenterType {

    // MARK: - Public Variables

    weak var view: PhotoViewType?

    // MARK: - Private Variables
    
    private let dataService: MarsRoverDataServiceType
    
    private let roverName: String
    private let solIndex: Int
    private let camera: String

    // MARK: - Lifecycle Functions
    
    init(view: PhotoViewType, roverName: String, solIndex: Int, camera: String, marsRoverDataService: MarsRoverDataServiceType) {
        self.view = view
        self.roverName = roverName
        self.solIndex = solIndex
        self.camera = camera
        self.dataService = marsRoverDataService
    }

    // MARK: - PhotoViewPresenterType Functions
    
    func viewDidLoad() {
        fetchRoverPhotos()
    }
}

private extension PhotoViewPresenter {
    
    private func fetchRoverPhotos() {
        
        view?.showLoading()
        dataService.getRoverPhotos(using: roverName, sol: solIndex, camera: camera) { [weak self] (photos, error) in
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.hideLoading()
                if error != nil {
                    self?.view?.showError(error!)
                    return
                }
                
                guard let self = self else { return }
                self.updateViewForPhotos(photos)
            }
        }
    }
    
    private func updateViewForPhotos(_ photos: RoverPhotos?) {
        if let photos = photos {
            self.view?.viewModel = PhotoViewModel(roverName: roverName, solIndex: solIndex, camera: camera, roverPhotos: photos)
        }
    }
}

