//
//  APIRequest.swift
//  MountRushmore
//
//  Created by Matthew Tong on 6/22/25.
//

import Foundation

struct APIRequest {
    
    func makeRequest<S: Decodable>(
        httpMethod: HttpMethod,
        path: String,
        body: (any Encodable)? = nil
    ) async throws -> S {
        var request = try createRequest(httpMethod: httpMethod, path: path)
        
        if let body = body {
            let httpBody = try JSONEncoder().encode(body)
            request.httpBody = httpBody
            
            if let bodyString = String(data: httpBody, encoding: .utf8) {
                print("Request body: \(bodyString)")
            }
        }
        
        return try await performRequest(request: request)
    }
    
    private func createRequest(httpMethod: HttpMethod, path: String) throws -> URLRequest {
        guard let url = URL(string: path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func performRequest<S: Decodable>(request: URLRequest) async throws -> S {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("HTTP Status Code: \(httpResponse.statusCode)")
        if let dataString = String(data: data, encoding: .utf8) {
            print("Response data: \(dataString)")
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(S.self, from: data)
    }
}

enum HttpMethod : String {
    case GET, POST
}
