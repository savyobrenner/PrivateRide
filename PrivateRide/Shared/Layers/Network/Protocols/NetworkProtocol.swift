//
//  NetworkProtocol.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

protocol NetworkProtocol {
    func sendRequest<Response: Decodable>(
        endpoint: Endpoint,
        responseModel: Response.Type
    ) async throws -> Response
}
