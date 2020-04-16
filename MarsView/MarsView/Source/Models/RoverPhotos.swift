//
//  RoverPhotos.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

struct RoverPhotos: Codable {
    let photos: [RoverPhoto]
}

struct RoverPhoto: Codable {
    let id: Int
    let sol: Int
    let camera: RoverCamera
    let imgSrc: String
    let earthDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sol
        case camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        sol = try values.decode(Int.self, forKey: .sol)
        camera = try values.decode(RoverCamera.self, forKey: .camera)
        imgSrc = try values.decode(String.self, forKey: .imgSrc)
        earthDate = try values.decode(String.self, forKey: .earthDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(sol, forKey: .sol)
        try container.encode(camera, forKey: .camera)
        try container.encode(imgSrc, forKey: .imgSrc)
        try container.encode(earthDate, forKey: .earthDate)
    }
}

struct RoverCamera: Codable {
    let id: Int
    let name: String
    let roverID: Int
    let fullName: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case roverID = "rover_id"
        case fullName = "full_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        roverID = try values.decode(Int.self, forKey: .roverID)
        fullName = try values.decode(String.self, forKey: .fullName)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(roverID, forKey: .roverID)
        try container.encode(fullName, forKey: .fullName)
    }
}
