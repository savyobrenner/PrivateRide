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
        responseModel: Response.Type,
        completion: @escaping (Result<Response, AppError>) -> Void
    ) {
        do {
            let request = try prepareRequest(for: endpoint)

            let task = urlSession.dataTask(with: request) { data, response, error in
                if let error = error as? URLError {
                    completion(.failure(.urlError(error)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.statusCode(httpResponse.statusCode)))
                    return
                }

                guard let data else {
                    completion(.failure(.unknown))
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(.invalidResponse))
                }
            }

            task.resume()
        } catch {
            completion(.failure(.invalidURL))
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
        return request
    }
}
