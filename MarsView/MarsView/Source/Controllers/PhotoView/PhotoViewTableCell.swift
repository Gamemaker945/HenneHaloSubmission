//
//  PhotoViewTableCell.swift
//  MarsView
//
//  Created by Christian Henne on 4/16/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SnapKit

class PhotoViewTableCell: UITableViewCell {
    
    // MARK: - Static Identifier
    
    static let identifier = "PhotoViewTableCell"
    
    // MARK: - Private Variables
    
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "loading")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var cameraNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
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
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    override func prepareForReuse() {
        cameraNameLabel.text = ""
        dateLabel.text = ""
        photoView.image = nil
    }
    
    // MARK: - Public Functions
    
    func setPhoto(_ photo: RoverPhoto) {
        cameraNameLabel.text = photo.camera.name
        dateLabel.text = photo.earthDate
        photoView.sd_setImage(with: URL(string: photo.imgSrc), placeholderImage: UIImage(named: "loading"))
    }
    
}

private extension PhotoViewTableCell {
    private func commonInit() {
        
        backgroundColor = .black
        contentView.backgroundColor = .clear
        
        addUIComponents()
        setupConstraints()
    }
    
    private func addUIComponents() {
        contentView.addSubview(photoView)
        contentView.addSubview(cameraNameLabel)
        contentView.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        
        photoView.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(10)
            $0.width.equalToSuperview().multipliedBy(0.65)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(photoView.snp.width).priority(.high)
        }
        
        dateLabel.snp.makeConstraints{
            $0.leading.equalTo(photoView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        cameraNameLabel.snp.makeConstraints{
            $0.leading.trailing.height.equalTo(dateLabel)
            $0.bottom.equalTo(dateLabel.snp.top).offset(-10)
        }
    }
}
