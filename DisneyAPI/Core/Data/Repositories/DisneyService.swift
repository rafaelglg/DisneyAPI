//
//  DisneyService.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

protocol DisneyService: Sendable {
    func getAllCharacters() async throws -> CharacterModel
}

final class DisneyServiceMock: DisneyService, Sendable {
    
    private let characters: CharacterModel
    let delay: Double

    init(characters: CharacterModel, delay: Double = 0.0) {
        self.characters = characters
        self.delay = delay
    }
    
    func getAllCharacters() async throws -> CharacterModel {
        try? await Task.sleep(for: .seconds(delay))
        return characters
    }
}

final class DisneyServiceImpl: DisneyService, Sendable {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }
    
    func getAllCharacters() async throws -> CharacterModel {
        try await networkService.fetchCharacters(urlString: Utilities.getURLPath(endingPath: .allCharacters))
    }
}
