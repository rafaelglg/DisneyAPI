//
//  CharacterManager.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 14/1/25.
//

import Foundation

@MainActor
@Observable
final class CharacterManagerImpl {
    
    private let repository: CharacterService
    private(set) var allCharacters: [CharacterDataResponse] = []
    private(set) var isLoading: Bool = false
    
    init(repository: CharacterService) {
        self.repository = repository
    }
    
    func getAllCharacters() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            allCharacters = try await repository.getAllCharacters().data
        } catch {
            print(error)
        }
    }
}
