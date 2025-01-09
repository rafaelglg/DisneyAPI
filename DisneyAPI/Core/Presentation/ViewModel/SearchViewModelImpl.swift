//
//  SearchViewModelImpl.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import Foundation

@MainActor
protocol Interactor {
    func getAllCharacters() async throws -> CharacterModel
    func searchCharacter(name: String) async throws -> CharacterModel
}

extension CoreInteractor: Interactor { }

@MainActor
@Observable
final class SearchViewModelImpl {
    
    private let interactor: Interactor
    private(set) var allCharacters: [CharacterDataResponse] = []
    private(set) var searchedCharacters: [CharacterDataResponse] = []
    
    private(set) var isLoading: Bool = false
    private(set) var promt: String = "Search your favorite character"
    
    var searchText: String = ""
    
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
    
    func searchCharacters(name: String) {
        
        guard !name.isEmpty else {
            return searchedCharacters = []
        }
        
        isLoading = true
        
        Task {
            defer { isLoading = false } 
            do {
                let searchedChar = try await interactor.searchCharacter(name: name)
                searchedCharacters = searchedChar.data
                print(searchedCharacters)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
