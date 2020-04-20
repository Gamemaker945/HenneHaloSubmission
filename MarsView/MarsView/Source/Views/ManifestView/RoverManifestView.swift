//
//  RoverManifestView.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RoverManifestView: UIView {
    
    // MARK: - Private Variables
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Manifest"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: TitleValueLabel = {
        let label = TitleValueLabel(frame: .zero)
        label.title = "Name:"
        return label
    }()
    
    private lazy var landingDateLabel: TitleValueLabel = {
        let label = TitleValueLabel(frame: .zero)
        label.title = "Landing Date:"
        return label
    }()
    
    private lazy var launchDateLabel: TitleValueLabel = {
        let label = TitleValueLabel(frame: .zero)
        label.title = "Launch Date:"
        return label
    }()
    
    private lazy var statusLabel: TitleValueLabel = {
        let label = TitleValueLabel(frame: .zero)
        label.title = "Status:"
        return label
    }()
    
    private lazy var maxSolLabel: TitleValueLabel = {
        let label = TitleValueLabel(frame: .zero)
        label.title = "Last Photo Sol:"
        return label
    }()
    
    private lazy var maxDateLabel: TitleValueLabel = {
        let label = TitleValueLabel(frame: .zero)
        label.title = "Last Photo Date:"
        return label
    }()
    
    private lazy var totalPhotosLabel: TitleValueLabel = {
        let label = TitleValueLabel(frame: .zero)
        label.title = "Total Photos:"
        return label
    }()
    
    // MARK: - Public Variables
    
    public var manifest: RoverManifest? {
        didSet {
            guard let manifest = manifest else { return }
            
            nameLabel.value = manifest.name
            landingDateLabel.value = manifest.landingDate
            launchDateLabel.value = manifest.launchDate
            statusLabel.value = manifest.status
            maxSolLabel.value = String(manifest.maxSol)
            maxDateLabel.value = manifest.maxDate
            totalPhotosLabel.value = String(manifest.totalPhotos)
        }
    }
    
    // MARK: - Lifecycle Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension RoverManifestView {

    private func setup() {
        
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(separator)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(landingDateLabel)
        stackView.addArrangedSubview(launchDateLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(maxSolLabel)
        stackView.addArrangedSubview(maxDateLabel)
        stackView.addArrangedSubview(totalPhotosLabel)
        
        setConstraints()
    }

    private func setConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        separator.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
}
