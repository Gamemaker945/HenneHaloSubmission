//
//  AnimatedLoadingIndicator.swift
//  MarsView
//
//  Created by Christian Henne on 4/20/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit

class AnimatedLoadingIndicator: UIView {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: animCells[0])
        return view
    }()
    
    private let animCells = ["Cell1", "Cell5", "Cell6", "Cell7", "Cell2", "Cell3", "Cell4"]
    
    private var timer: Timer?
    private var activeCellIndex = 0
    
    public var timeBetweenCells = TimeInterval(0.2) {
        didSet {
            timer?.invalidate()
            startAnim()
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
    
    public func startAnim() {
        timer = Timer.scheduledTimer(withTimeInterval: timeBetweenCells, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.activeCellIndex += 1
            if self.activeCellIndex >= self.animCells.count {
                self.activeCellIndex = 0
            }
            
            self.imageView.image = UIImage(named: self.animCells[self.activeCellIndex])
        }
       
    }
    
    public func stopAnim() {
        timer?.invalidate()
        timer = nil
    }
}

private extension AnimatedLoadingIndicator {

    private func setup() {
        
        self.addSubview(imageView)
        
        setConstraints()
        
    }

    private func setConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

