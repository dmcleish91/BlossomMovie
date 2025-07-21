//
//  Errors.swift
//  BlossomMovie
//
//  Created by Dwight Mcleish Jr on 7/13/25.
//

import Foundation

enum APIConfigError: Error, LocalizedError {
    case fileNotFound
    case dataLoadingFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "API configuration file not found"
        case .dataLoadingFailed(underlyingError: let error):
            return "Failed to load data: \(error.localizedDescription)"
        case .decodingFailed(underlyingError: let error):
            return "Decoding Failed: \(error.localizedDescription)."
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case badURLResponse(underlyingError: Error)
    case missingConfig
    case urlBuildFailed
    
    var errorDescription: String? {
        switch self {
        case .badURLResponse(underlyingError: let error):
            return "Bad URL Response: \(error.localizedDescription)"
        case .missingConfig:
            return "Missing API Configuration"
        case .urlBuildFailed:
            return "Failed to build URL"
        }
        
        
    }
}
