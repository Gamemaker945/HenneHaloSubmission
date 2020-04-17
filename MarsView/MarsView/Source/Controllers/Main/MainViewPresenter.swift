//
//  MainViewPresenter.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import PromiseKit

protocol MainViewPresenterType {
    func viewDidLoad()
    func roverSelected(_ rover: RoverModel)
}


final class MainViewPresenter: MainViewPresenterType {

    // MARK: - Public Variables
    
    weak var view: MainViewType?
    
    // MARK: - Private Variables
    
    private let dataService: MarsRoverDataServiceType
    
    // MARK: - Lifecycle Functions
    
    init(view: MainViewType, marsRoverDataService: MarsRoverDataServiceType) {
        self.view = view
        self.dataService = marsRoverDataService
    }
    
    // MARK: - MainViewPresenterType Functions
    
    func viewDidLoad() {
        let roverManager = RoverManager()
        if let rover = roverManager.rovers.first {
            if rover.manifest != nil {
                updateViewForRover(rover)
            } else {
                fetchRoverManifest(for: rover)
            }
        }
    }
    
    func roverSelected(_ rover: RoverModel) {
        if rover.manifest != nil {
            updateViewForRover(rover)
        } else {
            fetchRoverManifest(for: rover)
        }
    }
}

private extension MainViewPresenter {
    
    private func fetchRoverManifest(for rover: RoverModel?) {
        guard let rover = rover else { return }
        
        view?.showLoading()
        dataService.getRoverManifest(using: rover).done { [weak self] manifest in
            rover.manifest = manifest.photo_manifest
            self?.updateViewForRover(rover)
        }.ensure { [weak self] in
            self?.view?.hideLoading()
        }.catch { [weak self] error in
            self?.view?.showError(error)
            return
        }
    }
    
    private func updateViewForRover(_ rover: RoverModel?) {
        if let rover = rover {
            self.view?.viewModel = MainViewModel(rover: rover)
        }
    }
}
