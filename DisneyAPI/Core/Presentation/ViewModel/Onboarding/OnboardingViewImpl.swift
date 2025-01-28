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
    func signInAnonymously() async throws -> UserAuthModel
    var user: UserAuthModel? { get }
}

extension CoreInteractor: OnboardingViewInteractor { }

@MainActor
@Observable
final class OnboardingViewModelImpl {
    
    let interactor: OnboardingViewInteractor
    private(set) var allCharacters: [CharacterDataResponse] = []
    
    var user: UserAuthModel? {
        interactor.user
    }
    
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
    
    func signInAnonymously() {
        Task {
            do {
                _ = try await interactor.signInAnonymously()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func onAppear() {
        loadCharacters()
        signInAnonymously()
    }
    
    func updateViewState(showTabBarView: Bool) {
        interactor.updateViewState(showTabBarView: showTabBarView)
    }
    
    func updateViewState(showSignIn: Bool) {
        
        Task {
            try? await Task.sleep(for: .seconds(1.2))
            interactor.updateViewState(showSignIn: showSignIn)
        }
    }
}
