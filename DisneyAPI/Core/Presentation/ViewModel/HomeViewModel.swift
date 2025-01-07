//
//  HomeViewModel.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

@MainActor
protocol Interactor {
    func getAllCharacters() async throws -> CharacterModel
}

extension CoreInteractor: Interactor { }

import Foundation

@Observable
@MainActor
final class HomeViewModel {
    
    private let interactor: Interactor
    private(set) var allCharacters: [CharacterDataResponse] = []
    private(set) var isLoading: Bool = false
    
    init(interactor: Interactor) {
        self.interactor = interactor
    }
    
    func getAllCharacters() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await interactor.getAllCharacters()
            allCharacters = response.data
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
}
