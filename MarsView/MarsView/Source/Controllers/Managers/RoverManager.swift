//
//  RoverManager.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

class RoverManager {
    
    // MARK: - Singleton Instance
    
    class var instance:RoverManager {
        struct Singleton {
            static let instance = RoverManager()
        }
        
        return Singleton.instance
    }
    
    
    // MARK: - Public Variables
    
    let rovers = [RoverModel(name: "Curiosity"),
                  RoverModel(name: "Opportunity"),
                  RoverModel(name: "Spirit")]
    
    
    // MARK: - Public Functions
    
    func getRover(forName name: String) -> RoverModel? {
        for rover in rovers {
            if rover.name == name {
                return rover
            }
        }
        return nil
    }
}
