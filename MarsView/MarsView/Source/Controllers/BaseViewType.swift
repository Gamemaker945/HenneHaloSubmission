//
//  BaseViewType.swift
//  MarsView
//
//  Created by Christian Henne on 4/20/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

protocol BaseViewType: class {

    func showLoading()
    func hideLoading()
    
    func showError(_ error: Error)
}
