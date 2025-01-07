//
//  NetworkService.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import Foundation

protocol NetworkService: Sendable {
    func fetchCharacters() async throws -> CharacterModel
}

struct NetworkServiceImpl: NetworkService {

    func fetchCharacters() async throws -> CharacterModel {

        guard let url = URL(string: Utilities.getURLPath(endingPath: .allCharacters)) else {
            throw NetworkServiceError.badURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(CharacterModel.self, from: data)
        return decodedData
    }
}
