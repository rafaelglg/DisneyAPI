//
//  SearchViewModelImpl.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import Foundation

@MainActor
protocol SearchViewModelInteractor {
    var allCharacters: [CharacterDataResponse] { get }
}

extension CoreInteractor: SearchViewModelInteractor { }

@MainActor
@Observable
final class SearchViewModelImpl {
    
    private let interactor: SearchViewModelInteractor
    
    private(set) var searchedCharacters: [CharacterDataResponse] = []
    private(set) var isLoading: Bool = false
    private(set) var promt: String = "Search your favorite character"
        
    var searchText: String = ""
    var noSearchResult: Bool = false
    var recentSearches: [String] = []
    var isActiveSearch: Bool = false
    
    init(interactor: SearchViewModelInteractor) {
        self.interactor = interactor
    }
    
    func searchCharacters(name: String) {
        guard !name.isEmpty else {
            searchedCharacters = []
            return
        }
        isLoading = true
        defer {
            isLoading = false
        }
        
        searchedCharacters = interactor.allCharacters.filter {
            let name = $0.name?.lowercased().contains(name.lowercased()) ?? false
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
