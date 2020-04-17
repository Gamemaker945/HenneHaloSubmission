//
//  LoadingView.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

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
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        centerView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(backgroundView)
            $0.width.height.equalTo(100)
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.centerY.equalTo(centerView)
        }
        
        loadingLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(centerView)
            $0.top.equalTo(indicator.snp.bottom).offset(5)
            $0.height.equalTo(20)
        }
    }
}
