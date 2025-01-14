//
//  CoreInteractor.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

@MainActor
struct CoreInteractor {
    private let characterManager: CharacterManagerImpl
    
    init(characterManager: CharacterManagerImpl) {
        self.characterManager = characterManager
    }
    
    func getAllCharacters() async throws {
        await characterManager.getAllCharacters()
    }
    
    var allCharacters: [CharacterDataResponse] {
        characterManager.allCharacters
    }
}
