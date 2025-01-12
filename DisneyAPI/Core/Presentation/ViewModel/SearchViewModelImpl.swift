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
    var noSearchResult: Bool = false
    var recentSearches: [String] = []
    var isActiveSearch: Bool = false
    
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
            searchedCharacters = []
            return
        }
        isLoading = true
        
        searchedCharacters = allCharacters.filter {
            let name = $0.name?.lowercased().contains(name.lowercased()) ?? false
            
            isLoading = false
            return name
        }
        noSearchResult = searchedCharacters.isEmpty
    }
    
    func addRecentSearch(name: String) {
        guard !name.isEmpty, !recentSearches.contains(name) else { return }
        
        recentSearches.append(name)
        if recentSearches.count > 10 {
            recentSearches.removeFirst()
        }
    }
    
    func onClearRecentSearches() {
        recentSearches = []
    }
}
