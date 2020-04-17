//
//  MainViewController.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol MainViewType: class {
    var viewModel: MainViewModel? { get set }
    
    func showLoading()
    func hideLoading()
    
    func showError(_ error: Error)
}

struct MainViewModel {
    let rover: RoverModel
}

class MainViewController: UIViewController, MainViewType {
    
    // MARK: - Constants
    
    private struct Constants {
        struct Margins {
            static let side = CGFloat(25)
            static let top = CGFloat(25)
            static let backgroundEdge = CGFloat(16)
            static let sectionSeparation = CGFloat(40)
        }
        
        struct Sizes {
            static let pickerLabelHeight = CGFloat(20)
        }
    }
    
    // MARK: - Private Variables
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "mars_landscape")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var sectionOneBackground: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Welcome! Wanna see some cool Mars photos from the viewpoint of a real Mars rover? Select a rover to get started."
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var roverPickerView: RoverPickerView = {
        let view = RoverPickerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var roverManifestView: RoverManifestView = {
        let view = RoverManifestView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackViewSectionTwo: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var sectionTwoBackground: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var solPicker: DropDownPicker = {
        let picker = DropDownPicker(frame: .zero)
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.title = "Sol for photo:"
        return picker
    }()
    
    
    private lazy var cameraPicker: DropDownPicker = {
        let picker = DropDownPicker(frame: .zero)
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.title = "Camera for photo:"
        return picker
    }()
    
    private lazy var photoButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Show Me Photos!", for: .normal)
        button.addTarget(self, action: #selector(self.photoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var loadingView: LoadingView?
    
    private var activeSol = 0

    // MARK: - Public Variables
    
    var presenter: MainViewPresenterType?
    var viewModel: MainViewModel? {
        didSet {
            guard isViewLoaded else { return }
            updateUI(forViewModel: viewModel)
        }
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MARS VIEW"
        
        presenter = MainViewPresenter(view: self, marsRoverDataService: MarsRoverDataService(manifestClient: MarsRoverManifestClient(), photoClient: MarsRoverPhotoClient()))
        
        addUIElements()
        layoutUIElements()
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sectionOneBackground.layer.cornerRadius = 10
        sectionTwoBackground.layer.cornerRadius = 10
        photoButton.layer.cornerRadius = 10
    }
    
    
    // MARK: - MainViewType Functions
    
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
    
    // MARK: - Action Functions
    
    @objc
    func photoButtonPressed() {
        guard let viewModel = viewModel, let manifest = viewModel.rover.manifest else { return }
        let vc = PhotoViewController.make(roverName: viewModel.rover.name, solIndex: solPicker.selectedRow, camera: manifest.sols[activeSol].cameras[cameraPicker.selectedRow])
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension MainViewController: RoverPickerViewDelegate {
    
    func roverSelected(_ rover: RoverModel) {
        presenter?.roverSelected(rover)
    }
}

extension MainViewController: DropDownDataSource, DropDownPickerDelegate {
    
    func numberOfRowsIn(_ pickerView: DropDownPicker) -> Int {
        guard let manifest = viewModel?.rover.manifest else { return 0 }
        if pickerView == solPicker {
            return manifest.sols.count
        } else {
            return manifest.sols[activeSol].cameras.count
        }
    }
    
    func dropDownPicker(_ pickerView: DropDownPicker, titleForRow row: Int) -> String? {
        guard let manifest = viewModel?.rover.manifest else { return "" }
        if pickerView == solPicker {
            return "Sol \(row)"
        } else {
            return manifest.sols[activeSol].cameras[row]
        }
    }
    
    func dropDownPicker(_ pickerView: DropDownPicker, didSelectRow row: Int) {
        if pickerView == solPicker {
            activeSol = row
            cameraPicker.reloadAllComponents()
        }
    }
}

private extension MainViewController {
    
    private func addUIElements() {
        
        view.addSubview(backgroundImage)
        view.addSubview(scrollView)
        
        scrollView.addSubview(sectionOneBackground)
        scrollView.addSubview(stackView)
        scrollView.addSubview(sectionTwoBackground)
        scrollView.addSubview(stackViewSectionTwo)
        
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(roverPickerView)
        stackView.addArrangedSubview(roverManifestView)
        
        stackViewSectionTwo.addArrangedSubview(solPicker)
        stackViewSectionTwo.addArrangedSubview(cameraPicker)
        stackViewSectionTwo.addArrangedSubview(photoButton)
        
        stackView.setCustomSpacing(20, after: descriptionLabel)
        stackView.setCustomSpacing(40, after: roverPickerView)
        stackView.setCustomSpacing(40, after: roverManifestView)
    }
    
    private func layoutUIElements() {
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView).offset(Constants.Margins.top)
            $0.leading.equalTo(scrollView).offset(Constants.Margins.side)
            $0.trailing.equalTo(scrollView).offset(-Constants.Margins.side)
            $0.width.equalTo(scrollView).offset(-Constants.Margins.side * CGFloat(2))
        }
        
        sectionOneBackground.snp.makeConstraints {
            $0.top.leading.equalTo(stackView).offset(-Constants.Margins.backgroundEdge)
            $0.bottom.trailing.equalTo(stackView).offset(Constants.Margins.backgroundEdge)
        }
        
        stackViewSectionTwo.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(Constants.Margins.sectionSeparation)
            $0.leading.trailing.width.equalTo(stackView)
            $0.bottom.equalTo(scrollView)
        }
        
        sectionTwoBackground.snp.makeConstraints {
            $0.top.leading.equalTo(stackViewSectionTwo).offset(-Constants.Margins.backgroundEdge)
            $0.bottom.trailing.equalTo(stackViewSectionTwo).offset(Constants.Margins.backgroundEdge)
        }
        
        photoButton.snp.makeConstraints {
            $0.height.equalTo(Constants.Margins.sectionSeparation)
        }
    }
    
    private func updateUI(forViewModel viewModel: MainViewModel?) {
        guard let viewModel = viewModel else { return }
        roverManifestView.manifest = viewModel.rover.manifest
        
        solPicker.reloadAllComponents()
        cameraPicker.reloadAllComponents()
    }
}
