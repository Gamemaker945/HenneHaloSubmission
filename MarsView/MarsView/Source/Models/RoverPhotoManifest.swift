//
//  RoverManifest.swift
//  MarsView
//
//  Created by Christian Henne on 4/15/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import CoreData

struct RoverPhotoManifest: Codable {
    let photo_manifest: RoverManifest
}

struct RoverManifest: Codable {
    let name: String
    let landingDate: String
    let launchDate: String
    let status: String
    let maxSol: Int
    let maxDate: String
    let totalPhotos: Int
    let sols: [RoverManifestPhotoSol]
    
    enum CodingKeys: String, CodingKey {
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSol = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case sols = "photos"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        landingDate = try values.decode(String.self, forKey: .landingDate)
        launchDate = try values.decode(String.self, forKey: .launchDate)
        status = try values.decode(String.self, forKey: .status)
        maxSol = try values.decode(Int.self, forKey: .maxSol)
        maxDate = try values.decode(String.self, forKey: .maxDate)
        totalPhotos = try values.decode(Int.self, forKey: .totalPhotos)
        sols = try values.decode([RoverManifestPhotoSol].self, forKey: .sols)
    }
    
    init(from entity: RoverManifestEntity) {
        name = entity.name ?? ""
        landingDate = entity.landing_date ?? ""
        launchDate = entity.launch_date ?? ""
        status = entity.status ?? ""
        maxSol = Int(entity.max_sol)
        maxDate = entity.max_date ?? ""
        totalPhotos = Int(entity.total_photos)
        
        if let solsEntities = entity.photos {
            sols = solsEntities.map {
                return RoverManifestPhotoSol(from: $0 as! RoverManifestPhotoSolEntity)
            }
        } else {
            sols = []
        }
    }
    
    init(name: String, landingDate: String, launchDate: String, status: String, maxSol: Int, maxDate: String, totalPhotos: Int, sols: [RoverManifestPhotoSol]) {
        self.name = name
        self.landingDate = landingDate
        self.launchDate = launchDate
        self.status = status
        self.maxSol = maxSol
        self.maxDate = maxDate
        self.totalPhotos = totalPhotos
        self.sols = sols
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(landingDate, forKey: .landingDate)
        try container.encode(launchDate, forKey: .launchDate)
        try container.encode(status, forKey: .status)
        try container.encode(maxSol, forKey: .maxSol)
        try container.encode(maxDate, forKey: .maxDate)
        try container.encode(totalPhotos, forKey: .totalPhotos)
        try container.encode(sols, forKey: .sols)
    }
    
    func encode(to entity: RoverManifestEntity, using context: NSManagedObjectContext) {
        entity.name = name
        entity.landing_date = landingDate
        entity.launch_date = launchDate
        entity.status = status
        entity.max_sol = Int64(maxSol)
        entity.max_date = maxDate
        entity.total_photos = Int64(totalPhotos)
        
        let solEntities = entity.mutableSetValue(forKeyPath: #keyPath(RoverManifestEntity.photos))
        for sol in sols {
            let solEntity = RoverManifestPhotoSolEntity(context: context)
            sol.encode(to: solEntity)
            solEntities.add(solEntity)
        }
    }
}

struct RoverManifestPhotoSol: Codable {
    let sol: Int
    let earthDate: String
    let totalPhotos: Int
    let cameras: [String]
    
    
    enum CodingKeys: String, CodingKey {
        case sol
        case earthDate = "earth_date"
        case totalPhotos = "total_photos"
        case cameras
    }
    
    init(sol: Int, earthDate: String, totalPhotos: Int, cameras: [String]) {
        self.sol = sol
        self.earthDate = earthDate
        self.totalPhotos = totalPhotos
        self.cameras = cameras
    }
    
    init(from entity: RoverManifestPhotoSolEntity) {
        sol = Int(entity.sol)
        earthDate = entity.earth_date ?? ""
        totalPhotos = Int(entity.total_photos)
        cameras = entity.cameras ?? []
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sol = try values.decode(Int.self, forKey: .sol)
        
        if values.contains(.earthDate) {
            earthDate = try values.decode(String.self, forKey: .earthDate)
        } else {
            earthDate = "unknown"
        }
        totalPhotos = try values.decode(Int.self, forKey: .totalPhotos)
        cameras = try values.decode([String].self, forKey: .cameras)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sol, forKey: .sol)
        try container.encode(earthDate, forKey: .earthDate)
        try container.encode(totalPhotos, forKey: .totalPhotos)
        try container.encode(cameras, forKey: .cameras)
    }
    
    func encode(to entity: RoverManifestPhotoSolEntity) {
        entity.sol = Int32(sol)
        entity.earth_date = earthDate
        entity.total_photos = Int32(totalPhotos)
        entity.cameras = cameras
    }
}
