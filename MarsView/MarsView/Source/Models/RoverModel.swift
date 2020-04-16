//
//  RoverModel.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

class RoverModel: Equatable {
    let name: String
    var manifest: RoverManifest?
    
    init(name: String) {
        self.name = name
    }
    
    static func ==(lhs: RoverModel, rhs: RoverModel) -> Bool {
        return lhs.name == rhs.name
    }
}


