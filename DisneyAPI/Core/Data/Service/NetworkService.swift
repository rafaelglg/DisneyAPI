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
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}
