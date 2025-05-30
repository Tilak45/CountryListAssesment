//
//  NetworkClient.swift
//  CountryListAssessment
//
//  Created by Tilak k on 30/05/25.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(for endpoint: APIEndpoint, type: T.Type) async throws -> T
}

class NetworkClient: NetworkClientProtocol {
    func request<T: Decodable>(for endpoint: APIEndpoint, type: T.Type) async throws -> T {
        guard let url = endpoint.fullURL else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        if let body = endpoint.body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
