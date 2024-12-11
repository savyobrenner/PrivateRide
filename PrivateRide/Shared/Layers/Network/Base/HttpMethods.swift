//
//  HttpMethods.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

enum HttpMethods {
    case get
    case post

    var methodName: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}
