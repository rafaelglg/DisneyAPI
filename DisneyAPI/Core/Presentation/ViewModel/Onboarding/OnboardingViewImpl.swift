//
//  OnboardingViewInteractor.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 16/1/25.
//
import Foundation

@MainActor
protocol OnboardingViewInteractor {
    var allCharacters: [CharacterDataResponse] { get }
    
    func updateViewState(showTabBarView: Bool)
    func updateViewState(showSignIn: Bool)
    func getAllCharacters() async throws
}

extension CoreInteractor: OnboardingViewInteractor { }

@MainActor
@Observable
final class OnboardingViewModelImpl {
    
    let interactor: OnboardingViewInteractor
    private(set) var allCharacters: [CharacterDataResponse] = []
    
    init(interactor: OnboardingViewInteractor) {
        self.interactor = interactor
    }
    
    func loadCharacters() {
        guard interactor.allCharacters.isEmpty else {
            allCharacters = interactor.allCharacters
            print("Interactor already have characters no need to load again")
            return
        }
        
        Task {
            do {
                try await interactor.getAllCharacters()
                allCharacters = interactor.allCharacters
                print("characters load")
            } catch {
                print("Error loading characters: \(error)")
            }
        }
    }
    
    func updateViewState(showTabBarView: Bool) {
        interactor.updateViewState(showTabBarView: showTabBarView)
    }
    
    func updateViewState(showSignIn: Bool) {
        interactor.updateViewState(showSignIn: showSignIn)
    }
}
