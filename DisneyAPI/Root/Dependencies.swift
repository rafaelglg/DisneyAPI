//
//  Dependencies.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 15/1/25.
//

import SwiftUICore

@MainActor
struct Dependencies {
    let container: DependencyContainer
    let characterManager: DisneyManagerImpl
    let authManager: AuthManagerImpl
    let appState: AppStateImpl
    
    init() {
        self.characterManager = DisneyManagerImpl(repository: DisneyServiceImpl())
        // self.disneyManager = DisneyManagerImpl(repository: DisneyServiceMock(characters: .mock))
        self.authManager = AuthManagerImpl(repository: FirebaseAuthService())
        self.appState = AppStateImpl()
        
        let container = DependencyContainer()
        container.register(DisneyManagerImpl.self, service: characterManager)
        container.register(AuthManagerImpl.self, service: authManager)
        container.register(AppStateImpl.self, service: appState)
        self.container = container
    }
}

extension View {
    func previewEnvironment() -> some View {
        self
            .environment(DevPreview.shared.container)
    }
}

@MainActor
struct DevPreview {
    static let shared = DevPreview()
    
    var container: DependencyContainer {
        let container = DependencyContainer()
        container.register(DisneyManagerImpl.self, service: characterManager)
        container.register(AuthManagerImpl.self, service: authManager)
        container.register(AppStateImpl.self, service: appState)
        return container
    }
    
    let characterManager: DisneyManagerImpl
    let authManager: AuthManagerImpl
    let appState: AppStateImpl
    
    init() {
        self.characterManager = DisneyManagerImpl(repository: DisneyServiceMock(characters: .mock))
        self.authManager = AuthManagerImpl(repository: MockAuthService())
        self.appState = AppStateImpl()
    }
}
