//
//  DropDownPickerCell.swift
//  MarsView
//
//  Created by Christian Henne on 4/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SnapKit

class DropDownPickerCell: UITableViewCell {
    
    // MARK: - Static Identifier
    
    static let identifier = "DropDownPickerCell"
    
    // MARK: - Private Variables
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle Functions
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func prepareForReuse() {
        label.text = ""
    }
    
    // MARK: - Public Functions
    
    func setValue(_ value: String) {
        label.text = value
    }
    
}

private extension DropDownPickerCell {
    private func commonInit() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        contentView.backgroundColor = .clear
        
        addUIComponents()
        setupConstraints()
    }
    
    private func addUIComponents() {
        contentView.addSubview(label)
    }
    
    private func setupConstraints() {
        
        label.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.top.equalToSuperview()
        }
    }
}
