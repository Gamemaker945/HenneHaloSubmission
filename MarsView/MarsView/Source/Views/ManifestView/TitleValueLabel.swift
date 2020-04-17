//
//  TitleValueLabel.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

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
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(20)
        }
        
        valueLabel.snp.makeConstraints {
            $0.top.height.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalToSuperview()
        }
    }
}
