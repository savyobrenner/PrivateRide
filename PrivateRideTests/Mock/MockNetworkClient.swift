//
//  MockNetworkClient.swift
//  Pokedex
//
//  Created by Savyo Brenner on 04/10/24.
//

import Foundation
@testable import PrivateRide

final class MockNetworkClient: NetworkProtocol {
    var shouldFail = false
    var mockData: Data?

    func sendRequest<Response: Decodable>(endpoint: Endpoint, responseModel: Response.Type) async throws -> Response {
        if shouldFail {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
        }

        guard let data = mockData else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"])
        }

        let response = try JSONDecoder().decode(responseModel, from: data)
        return response
    }

    func sendRequest<Response: Decodable>(url: URL, responseModel: Response.Type) async throws -> Response {
        if shouldFail {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
        }

        guard let data = mockData else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"])
        }

        let response = try JSONDecoder().decode(responseModel, from: data)
        return response
    }
}
