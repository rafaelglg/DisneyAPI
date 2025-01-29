//
//  CoreInteractor.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

@MainActor
struct CoreInteractor {
    private let disneyManager: DisneyManagerImpl
    private let authManager: AuthManagerImpl
    private let appState: AppStateImpl
    
    init(container: DependencyContainer) {
        self.disneyManager = container.resolve(DisneyManagerImpl.self)!
        self.authManager = container.resolve(AuthManagerImpl.self)!
        self.appState = container.resolve(AppStateImpl.self)!
    }
    
    // MARK: - Disney manager
    
    var allCharacters: [CharacterDataResponse] {
        return disneyManager.allCharacters
    }
    
    func getAllCharacters() async throws {
        await disneyManager.getAllCharacters()
    }
    
    // MARK: - App state
    
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
    
    func updateViewState(showTabBarView: Bool) {
        appState.updateViewState(showTabBarView: showTabBarView)
    }
    
    func updateViewState(showSignIn: Bool) {
        appState.updateViewState(showSignIn: showSignIn)
    }
    
    // MARK: - Authentication Service (Firebase)
    
    var user: UserAuthModel? {
        authManager.user
    }
    
    func signIn(email: String, password: String) async throws {
        try await authManager.signIn(email: email, password: password)
    }
    
    func signInAnonymously() async throws -> UserAuthModel {
        try await authManager.signInAnonymously()
    }
    
    func signUp(email: String, password: String) async throws {
        try await authManager.signUp(email: email, password: password)
    }
    
    func reAuthenticateUser() async throws {
        try await authManager.reAuthenticateUser()
    }
    
    func sendPasswordReset(email: String) async throws {
        try await authManager.sendPasswordReset(email: email)
    }
    
    func getCurrentUser() throws -> UserAuthModel? {
        try authManager.getCurrentUser()
    }
    
    func signOut() throws {
        try authManager.signOut()
    }
    
    func deleteAccount() async throws {
        try await authManager.deleteAccount()
    }
    
    func signInWithGoogle() async throws {
        try await authManager.signInWithGoogle()
    }
    
    func isValidEmail(email: String) -> Bool {
        authManager.isValidEmail(email: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        authManager.isValidPassword(password: password)
    }
}
