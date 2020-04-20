//
//  PhotoViewController.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoViewType: BaseViewType {
    var viewModel: PhotoViewModel? { get set }
}

struct PhotoViewModel {
    
    let roverName: String
    let solIndex: Int
    let camera: String
    let roverPhotos: RoverPhotos
}

class PhotoViewController: UIViewController, PhotoViewType {

    // MARK: - Constants
    private struct Constants {
        struct Margins {
            static let noImagesSide = CGFloat(25)
        }
    }
    
    // MARK: - Private Variables
    
    private lazy var table: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(PhotoViewTableCell.self, forCellReuseIdentifier: PhotoViewTableCell.identifier)
        table.separatorStyle = .none
        table.tableHeaderView = UIView(frame: .zero)
        table.tableFooterView = UIView(frame: .zero)
        table.backgroundColor = .clear
        return table
    }()
    
    private lazy var noImagesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "There were no images found for this sol, camera combination. Please go back and pick another combination."
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private var loadingView: LoadingView?
    
    // MARK: - Public Variables
    
    var presenter: PhotoViewPresenterType?
    var viewModel: PhotoViewModel? {
        didSet {
            guard isViewLoaded else { return }
            updateUI(forViewModel: viewModel)
        }
    }
    
    // MARK: - Static Factory Methods
    static func make(roverName: String, solIndex: Int, camera: String, marsRoverDataService: MarsRoverDataService) -> PhotoViewController {
        let viewController = PhotoViewController()
        let presenter = PhotoViewPresenter(view: viewController, roverName: roverName, solIndex: solIndex, camera: camera, marsRoverDataService: marsRoverDataService)
        viewController.presenter = presenter
        return viewController
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PHOTOS"
        
        view.backgroundColor = .black
        addUIElements()
        layoutUIElements()
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - PhotoViewType Functions
    
    func showLoading() {
        loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView!)
    }
    
    func hideLoading() {
        if let loadingView = loadingView {
            loadingView.removeFromSuperview()
            self.loadingView = nil
        }
    }
    
    func showError(_ error: Error) {
        guard let error = error as? MarsRoverClientError else { return }
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

extension PhotoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.roverPhotos.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoViewTableCell.identifier, for: indexPath) as? PhotoViewTableCell else {
            fatalError("PhotoViewController configured incorrectly for reuse ID \(PhotoViewTableCell.identifier)")
        }
        
        if let viewModel = viewModel {
            let photoInfo = viewModel.roverPhotos.photos[indexPath.row]
            cell.setPhoto(photoInfo)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else { return nil }
        let view = PhotoViewTableHeaderView()
        view.roverName = viewModel.roverName
        view.roverSol = "Sol: \(viewModel.solIndex)"
        view.roverCamera = "Camera: " + viewModel.camera
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

private extension PhotoViewController {
    
    private func addUIElements() {
        view.addSubview(table)
        view.addSubview(noImagesLabel)
    }
    
    private func layoutUIElements() {
        
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        noImagesLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.Margins.noImagesSide)
            $0.trailing.equalToSuperview().offset(-Constants.Margins.noImagesSide)
        }
    }
    
    private func updateUI(forViewModel viewModel: PhotoViewModel?) {
        guard let viewModel = viewModel else { return }
        table.reloadData()
        
        noImagesLabel.isHidden = viewModel.roverPhotos.photos.count > 0
    }
}
