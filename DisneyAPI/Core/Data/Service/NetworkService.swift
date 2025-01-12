//
//  NetworkService.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import Foundation

protocol NetworkService: Sendable {
    func fetchCharacters<T>(urlString: String) async throws -> T where T: Codable
}

struct NetworkServiceImpl: NetworkService {

    func fetchCharacters<T>(urlString: String) async throws -> T where T: Codable {

        guard let url = URL(string: urlString) else {
            throw NetworkServiceError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        try handleResponse(response: response)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
    
    private func handleResponse(response: URLResponse) throws {
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkingError.invalidStatusCode(statusCode: -1)
        }
        
        guard (300...400).contains(statusCode) else {
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
    }
}

enum NetworkingError: Error, LocalizedError {
    case encodingFailed(innerError: EncodingError)
    case decodingFailed(innerError: DecodingError)
    case invalidStatusCode(statusCode: Int)
    case requestFailed(innerError: URLError)
    case otherError(innerError: Error)
    
    var errorDescription: String? {
        switch self {
        case .encodingFailed(let innerError):
            return "Encoding failed \(innerError)"
        case .decodingFailed(let innerError):
            return "Decoding failed \(innerError)"
        case .invalidStatusCode(let statusCode):
            return "The status code is \(statusCode)"
        case .requestFailed(let innerError):
            return "Request failed \(innerError)"
        case .otherError(let innerError):
            return "Other error\(innerError)"
        }
    }
}
