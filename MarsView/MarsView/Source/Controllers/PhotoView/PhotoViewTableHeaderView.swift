//
//  PhotoViewTableHeaderView.swift
//  MarsView
//
//  Created by Christian Henne on 4/16/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PhotoViewTableHeaderView: UIView {
    
    // MARK: - Constants
    private struct Constants {
        struct Margins {
            static let sides = CGFloat(15)
        }
    }
    
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
    
    private lazy var roverNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var roverSolLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var roverCameraLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Public Variables
    
    public var roverName: String = "" {
        didSet {
            roverNameLabel.text = roverName
        }
    }
    
    public var roverSol: String = "" {
        didSet {
            roverSolLabel.text = roverSol
        }
    }
    
    public var roverCamera: String = "" {
        didSet {
            roverCameraLabel.text = roverCamera
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

private extension PhotoViewTableHeaderView {

    private func setup() {
        
        backgroundColor = .black
        
        addSubview(stackView)
        stackView.addArrangedSubview(roverNameLabel)
        stackView.addArrangedSubview(roverSolLabel)
        stackView.addArrangedSubview(roverCameraLabel)
        
        setConstraints()
    }

    private func setConstraints() {
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(Constants.Margins.sides)
            $0.bottom.equalToSuperview().offset(-Constants.Margins.sides)
        }
    }
}
