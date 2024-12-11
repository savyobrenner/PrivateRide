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
    case unknown
}

