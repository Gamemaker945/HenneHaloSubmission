//
//  MarsRoverBaseDataClient.swift
//  MarsView
//
//  Created by Christian Henne on 4/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

// MARK: - Client Error Type

enum MarsRoverClientError: Error {
    
    case serverError
    case wrongMimeType
    case decodingError
    case unknownError
    
    public var localizedDescription: String {
        switch self {
        case .serverError, .unknownError:
            return NSLocalizedString("There was an error at the server. Please try again later.", comment: "Fetch Error")
        case .wrongMimeType, .decodingError:
            return NSLocalizedString("There was an issue with the data returned. Please try again later.", comment: "Fetch Error")
        }
    }
}

protocol MarsRoverBaseDataClient {
    var apiKey: String { get }
    var baseApiURL: String { get }
}

extension MarsRoverBaseDataClient {
    
    var apiKey: String {
        return "api_key=oRuTcpFkyrrXlxdfRw9IxweaVMBIwt4ZOfvfZoZC"
    }
    
    var baseApiURL: String {
        return "https://api.nasa.gov/mars-photos/api/v1/"
    }
}
