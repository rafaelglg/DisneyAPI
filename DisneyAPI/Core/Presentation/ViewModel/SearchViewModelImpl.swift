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
    
    private var debounceTask: Task<Void, Never>?
    
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
        // Realiza la búsqueda inmediatamente
        Task {
            await performSearch(name: name)
        }
        
        // Aplica debounce solo a la actualización de `recentSearches`
        debounceTask?.cancel()
        debounceTask = Task {
            do {
                try await Task.sleep(for: .seconds(1))  // 1 segundo de retraso
                
                // Asegúrate de que la tarea no haya sido cancelada
                guard !Task.isCancelled else { return }
                addRecentSearch(name: name)
            } catch {
                if !(error is CancellationError) {
                    print("Error no relacionado con la cancelación: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func performSearch(name: String) async {
        guard !name.isEmpty else {
            searchedCharacters = []
            return
        }
        
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            let searchedChar = try await interactor.searchCharacter(name: name)
            searchedCharacters = searchedChar.data
            noSearchResult = searchedChar.data.isEmpty
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func addRecentSearch(name: String) {
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
