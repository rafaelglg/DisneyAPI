//
//  CoreInteractor.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

struct CoreInteractor {
    private let characterRepository: CharacterService
    
    init(characterRepository: CharacterService) {
        self.characterRepository = characterRepository
    }
    
    func getAllCharacters() async throws -> CharacterModel {
        try await characterRepository.getAllCharacters()
    }
}
