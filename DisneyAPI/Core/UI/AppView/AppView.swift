//
//  AppView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 12/1/25.
//

import SwiftUI

struct AppView: View {
    
    @Environment(CharacterManagerImpl.self) var characterManager
    @Environment(AppStateImpl.self) var appState
    
    var body: some View {
        ZStack {
            if appState.showTabBar {
                TabbarView()
                    .transition(.move(edge: .trailing))
            } else {
                OnboardingView()
                    .transition(.move(edge: .leading))
            }
        }
        .task {
            await characterManager.getAllCharacters()
        }
        .animation(.smooth, value: appState.showTabBar)
    }
}

#Preview("Production") {
    
    @Previewable @State var manager = CharacterManagerImpl(
        repository: CharacterServiceImpl()
    )
    
    AppView()
        .environment(manager)
        .environment(AppStateImpl())
        .task {
            await manager.getAllCharacters()
        }
}

#Preview("Mock") {
    
    @Previewable @State var manager = CharacterManagerImpl(
        repository: CharacterServiceMock(
            characters: .mock, delay: 2.0
        )
    )
    
    AppView()
        .environment(manager)
        .environment(AppStateImpl())
        .task {
            await manager.getAllCharacters()
        }
}
