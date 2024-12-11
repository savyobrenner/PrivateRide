//
//  NetworkClient.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Foundation

final class NetworkClient: NetworkProtocol {
    private let urlSession: URLSession
    
    init(session: URLSession = .shared) {
        self.urlSession = session
    }
    
    func sendRequest<Response: Decodable>(
        endpoint: Endpoint,
        responseModel: Response.Type
    ) async throws -> Response {
        do {
            let request = try prepareRequest(for: endpoint)
            
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let backendError = try? JSONDecoder().decode(PRError.self, from: data) {
                    throw AppError.backendError(backendError)
                }
                
                throw AppError.statusCode(httpResponse.statusCode)
            }
                        
            do {
                let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                return decodedResponse
            } catch {
                throw AppError.invalidResponse
            }
        } catch let urlError as URLError {
            throw AppError.urlError(urlError)
        } catch let appError as AppError {
            throw appError
        } catch {
            throw AppError.unknown
        }
    }
    
    private func prepareRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard let url = endpoint.url else {
            throw AppError.invalidURL
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = endpoint.queryParameters.isEmpty ? nil : endpoint.queryParameters
        
        guard let finalURL = components?.url else {
            throw AppError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.request.methodName
        endpoint.requestSpecificHeaders.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        if let bodyParameters = endpoint.bodyParameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
                request.httpBody = jsonData
            } catch {
                throw AppError.invalidRequest("Failed to serialize body parameters.")
            }
        }
        
        return request
    }
}
