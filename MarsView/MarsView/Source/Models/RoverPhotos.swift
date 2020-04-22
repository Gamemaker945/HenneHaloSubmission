//
//  RoverPhotos.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import CoreData

struct RoverPhotos: Codable {
    let photos: [RoverPhoto]
    
    init(photos: [RoverPhoto]) {
        self.photos = photos
    }
    
    init(from entity: RoverPhotosEntity) {
        if let photoEntities = entity.photos {
            photos = photoEntities.map {
                return RoverPhoto(from: $0 as! RoverPhotoEntity)
            }
        } else {
            photos = []
        }
    }
    
    func encode(to entity: RoverPhotosEntity, using context: NSManagedObjectContext) {
        let photosEntities = entity.mutableSetValue(forKeyPath: #keyPath(RoverPhotosEntity.photos))
        for photo in photos {
            let photoEntity = RoverPhotoEntity(context: context)
            photo.encode(to: photoEntity, using: context)
            photosEntities.add(photoEntity)
        }
    }
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
    
    init(id: Int, sol: Int, camera: RoverCamera, imgSrc: String, earthDate: String) {
        self.id = id
        self.sol = sol
        self.camera = camera
        self.imgSrc = imgSrc
        self.earthDate = earthDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        sol = try values.decode(Int.self, forKey: .sol)
        camera = try values.decode(RoverCamera.self, forKey: .camera)
        imgSrc = try values.decode(String.self, forKey: .imgSrc)
        earthDate = try values.decode(String.self, forKey: .earthDate)
    }
    
    init(from entity: RoverPhotoEntity) {
        id = Int(entity.id)
        sol = Int(entity.sol)
        
        imgSrc = entity.image_src ?? ""
        earthDate = entity.earth_date ?? ""
        
        let cameraEntity = entity.camera
        camera = RoverCamera(from: cameraEntity!)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(sol, forKey: .sol)
        try container.encode(camera, forKey: .camera)
        try container.encode(imgSrc, forKey: .imgSrc)
        try container.encode(earthDate, forKey: .earthDate)
    }
    
    func encode(to entity: RoverPhotoEntity, using context: NSManagedObjectContext) {
        entity.id = Int64(id)
        entity.sol = Int64(sol)
        entity.image_src = imgSrc
        entity.earth_date = earthDate
        
        let cameraEntity = RoverCameraEntity(context: context)
        camera.encode(to: cameraEntity, using: context)
        entity.camera = cameraEntity
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
    
    init(id: Int, name: String, roverID: Int, fullName: String) {
        self.id = id
        self.name = name
        self.roverID = roverID
        self.fullName = fullName
    }
    
    init(from entity: RoverCameraEntity) {
        id = Int(entity.id)
        roverID = Int(entity.rover_id)
        
        name = entity.name ?? ""
        fullName = entity.full_name ?? ""
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
    
    func encode(to entity: RoverCameraEntity, using context: NSManagedObjectContext) {
        entity.id = Int64(id)
        entity.rover_id = Int64(roverID)
        entity.name = name
        entity.full_name = fullName
    }
}
