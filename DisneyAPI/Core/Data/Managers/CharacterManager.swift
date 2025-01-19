//
//  CharacterManager.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 14/1/25.
//

import Foundation

@MainActor
@Observable
final class DisneyManagerImpl {
    
    private let repository: DisneyService
    private(set) var allCharacters: [CharacterDataResponse] = []
    private(set) var isLoading: Bool = false
    
    init(repository: DisneyService) {
        self.repository = repository
    }
    
    func getAllCharacters() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            allCharacters = try await repository.getAllCharacters().data
        } catch {
            print(error.localizedDescription)
        }
    }
}
