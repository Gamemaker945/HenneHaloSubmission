//
//  TitleValueLabel.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit

class TitleValueLabel: UIView {

    // MARK: - Private Variables
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Title: "
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "--"
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Public Variables
    
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var value: String = "--" {
        didSet {
            valueLabel.text = value
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

private extension TitleValueLabel {
    
    private func setup() {
        
        self.addSubview(titleLabel)
        self.addSubview(valueLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 150),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            valueLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor)
        ])
    }
    
}
