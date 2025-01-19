//
//  CoreInteractor.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

@MainActor
struct CoreInteractor {
    private let characterManager: DisneyManagerImpl
    private let authManager: AuthManagerImpl
    private let appState: AppStateImpl
    
    init(container: DependencyContainer) {
        self.characterManager = container.resolve(DisneyManagerImpl.self)!
        self.authManager = container.resolve(AuthManagerImpl.self)!
        self.appState = container.resolve(AppStateImpl.self)!
    }
    
    var allCharacters: [CharacterDataResponse] {
        return characterManager.allCharacters
    }
    
    var showTabBar: Bool {
        return appState.showTabBar
    }
    
    var shouldPresentSignIn: Bool {
        get {
            appState.shouldPresentSignIn
        } set {
            appState.shouldPresentSignIn = newValue
        }
    }
    
    func getAllCharacters() async throws {
        await characterManager.getAllCharacters()
    }
    
    func signIn(email: String, password: String) async throws {
        try await authManager.signIn(email: email, password: password)
    }
    
    func updateViewState(showTabBarView: Bool) {
        appState.updateViewState(showTabBarView: showTabBarView)
    }
    
    func updateViewState(showSignIn: Bool) {
        appState.updateViewState(showSignIn: showSignIn)
    }
}
