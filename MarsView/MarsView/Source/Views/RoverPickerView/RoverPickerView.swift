//
//  RoverPickerView.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit

protocol RoverPickerViewDelegate {
    func roverSelected(_ rover: RoverModel)
}

class RoverPickerView: UIView {
    
    // MARK: - Private Variables
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 1
        return stackView
    }()
    
    private var rovers: [RoverModel] = []
    
    // MARK: - Public Variables
    
    public var delegate: RoverPickerViewDelegate?
    
    // MARK: - Lifecycle Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        rovers = RoverManager().rovers
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RoverPickerView: RoverViewDelegate {
    func roverSelected(_ rover: RoverModel) {
        for subview in stackView.arrangedSubviews {
            if let roverView = subview as? RoverView {
                roverView.state = roverView.rover == rover ?.selected : .unSelected
            }
        }
        delegate?.roverSelected(rover)
    }
}

private extension RoverPickerView {
    
    private func setup() {
        
        self.addSubview(stackView)
        
        for (index, rover) in rovers.enumerated() {
            let roverView = RoverView(frame: .zero)
            roverView.translatesAutoresizingMaskIntoConstraints = false
            roverView.rover = rover
            roverView.state = index == 0 ? .selected : .unSelected
            roverView.delegate = self
            stackView.addArrangedSubview(roverView)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
