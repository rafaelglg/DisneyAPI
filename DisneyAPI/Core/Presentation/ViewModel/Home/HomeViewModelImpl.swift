//
//  HomeViewModelImpl.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 14/1/25.
//
import Foundation

@MainActor
protocol HomeViewModelInteractor {
    var allCharacters: [CharacterDataResponse] { get }
}

extension CoreInteractor: HomeViewModelInteractor { }

@Observable
@MainActor
final class HomeViewModelImpl {
    let interactor: HomeViewModelInteractor
    
    private(set) var isLoading: Bool = true
    private(set) var allCharacters: [CharacterDataResponse] = []
    
    init(interactor: HomeViewModelInteractor) {
        self.interactor = interactor
    }
    
    func refreshCharacters() {
        /// To avoid reloading of characters when allCharacters from the viewmodel has information already
        guard allCharacters.isEmpty else { return }
        
        /// If interactor.allCharacters has info already set the info to viewmodel
        guard interactor.allCharacters.isEmpty else {
            let characters = interactor.allCharacters.shuffled().first(10)
            print("Interactor already have characters no need to load again")
            getCharacters(characters)
            return
        }
    }
    
    /// Sets the new value coming interactor.allCharacters to the ViewModel
    func getCharacters(_ newValue: [CharacterDataResponse]) {
        isLoading = false
        allCharacters = newValue.shuffled().first(10)
    }
}
