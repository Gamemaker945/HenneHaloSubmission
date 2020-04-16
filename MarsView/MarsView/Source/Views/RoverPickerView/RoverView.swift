//
//  RoverView.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit

enum RoverState {
    case selected
    case unSelected
    
    func getImage() -> String {
        switch self {
        case .selected: return "rover_selected"
        case .unSelected: return "rover_unselected"
        }
    }
}

protocol RoverViewDelegate {
    func roverSelected(_ rover: RoverModel)
}

class RoverView: UIView {
    
    // MARK: - Constants
    
    private struct Constants {
       struct Margins {
           static let side = CGFloat(20)
           static let top = CGFloat(10)
        }
    }
    
    // MARK: - Private Variables
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var roverImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "rover_unselected")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Public Variables
    
    public var state: RoverState = .unSelected {
        didSet {
            roverImage.image = UIImage(named: state.getImage())
            nameLabel.font = state == .unSelected ? UIFont.systemFont(ofSize: 14) : UIFont.systemFont(ofSize: 14, weight: .bold)
        }
    }
    
    public var rover: RoverModel? {
        didSet {
            nameLabel.text = rover?.name ?? ""
        }
    }
    
    public var delegate: RoverViewDelegate?
    
    // MARK: - Lifecycle Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action Functions
    
    @objc
    func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        guard let rover = rover, state != .selected else { return }
        delegate?.roverSelected(rover)
    }
}

private extension RoverView {
    
    private func setup() {
        
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(roverImage)
        stackView.addArrangedSubview(nameLabel)
        
        setConstraints()
        
        roverImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        roverImage.addGestureRecognizer(tapGesture)
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            roverImage.heightAnchor.constraint(equalTo: roverImage.widthAnchor),
        ])
    }
    
}
