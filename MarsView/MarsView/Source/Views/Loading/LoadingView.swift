//
//  LoadingView.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    // MARK: - Private Variables
    
    private lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var centerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        return view
    }()
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Loading"
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Lifecycle Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        centerView.layer.cornerRadius = 10
    }
    
}

private extension LoadingView {

    private func setup() {
        
        self.addSubview(backgroundView)
        backgroundView.addSubview(centerView)
        centerView.addSubview(indicator)
        centerView.addSubview(loadingLabel)
        
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            centerView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            centerView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            centerView.widthAnchor.constraint(equalToConstant: 100),
            centerView.heightAnchor.constraint(equalToConstant: 100),
            
            indicator.centerXAnchor.constraint(equalTo: centerView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerView.centerYAnchor),
            
            loadingLabel.leadingAnchor.constraint(equalTo: centerView.leadingAnchor),
            loadingLabel.trailingAnchor.constraint(equalTo: centerView.trailingAnchor),
            loadingLabel.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 5),
            loadingLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
