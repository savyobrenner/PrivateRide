//
//  AppError.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Foundation

enum AppError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case invalidRequest(String)
    case statusCode(Int)
    case urlError(URLError)
    case backendError(PRError)
    case unknown
}

struct PRError: Codable, Equatable {
    let code: String
    let errorLocalized: String
    
    private enum CodingKeys: String, CodingKey {
        case code = "error_code"
        case errorLocalized = "error_description"
    }
}
