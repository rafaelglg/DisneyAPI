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
    private let userManager: UserManagerImpl
    
    init(container: DependencyContainer) {
        self.disneyManager = container.resolve(DisneyManagerImpl.self)!
        self.authManager = container.resolve(AuthManagerImpl.self)!
        self.appState = container.resolve(AppStateImpl.self)!
        self.userManager = container.resolve(UserManagerImpl.self)!
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
    
    // MARK: - User manager
    
    var currentUser: UserModel? {
        userManager.currentUser
    }
    
    func getCurrentUser(userId: String) async throws -> UserModel {
        
        guard let user = await userManager.getCurrentUser(userId: userId) else {
            /// This method is when a user is deleted from Database but firebase has saved the user locally so to set it to nil to create a anonymously 
            setUserAuthToNil()
            throw UserManagerError.noUserId
        }
        
        return user
    }
    
    func logIn(user: UserModel) async throws {
        try await userManager.saveUser(user: user)
    }
    
    // MARK: - Authentication Service (Firebase)
    
    var userAuth: UserAuthModel? {
        authManager.user
    }
    
    func getUserAuthId() -> String {
        userAuth?.id ?? ""
    }
    
    func signIn(email: String, password: String) async throws -> UserAuthModel {
        return try await authManager.signIn(email: email, password: password)
    }
    
    func signInAnonymously() async throws -> UserAuthModel {
        try await authManager.signInAnonymously()
    }
    
    func signUp(email: String, password: String) async throws -> UserAuthModel {
        try await authManager.signUp(email: email, password: password)
    }
    
    func reAuthenticateUser() async throws {
        try await authManager.reAuthenticateUser()
    }
    
    func sendPasswordReset(email: String) async throws {
        try await authManager.sendPasswordReset(email: email)
    }
    
    func getUserAuth() -> UserAuthModel? {
        authManager.getUserAuth()
    }
    
    func signInWithGoogle() async throws -> UserAuthModel {
        try await authManager.signInWithGoogle()
    }
    
    func isValidEmail(email: String) -> Bool {
        authManager.isValidEmail(email: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        authManager.isValidPassword(password: password)
    }
    
    func setUserAuthToNil() {
        authManager.setUserToNil()
    }
    
    // MARK: - SHARED
    func deleteAccount() async throws {
        let id = getUserAuthId()
        try await authManager.deleteAccount()
        try await userManager.deleteUser(userId: id)
        setUserAuthToNil()
        updateViewState(showTabBarView: false)
    }
    
    func signOut() throws {
        try authManager.signOut()
        userManager.signOut()
        updateViewState(showTabBarView: false)
    }
}
