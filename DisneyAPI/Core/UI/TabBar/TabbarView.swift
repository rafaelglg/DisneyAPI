//
//  TabbarView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 6/1/25.
//

import SwiftUI

struct TabbarView: View {
    
    @Environment(AppStateImpl.self) var appState
    @Environment(CharacterManagerImpl.self) var characterManager
    
    var body: some View {
        @Bindable var appState = appState
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView(
                    viewModel: SearchViewModelImpl(
                        interactor: CoreInteractor(
                            characterManager: characterManager
                        )
                    )
                )
            }
            
            Tab("Profile", systemImage: "person") {
                ProfileView()
            }
        }
        .sheet(isPresented: $appState.shouldPresentSignIn) {
            SignInProcessView()
                .presentationDetents([.fraction(0.45)])
        }
    }
}

#Preview("Real characters") {
    
    @Previewable @State var manager = CharacterManagerImpl(
        repository: CharacterServiceImpl()
    )
    @Previewable @State var appState = AppStateImpl()
    appState.shouldPresentSignIn = true
    
    return TabbarView()
        .environment(manager)
        .environment(appState)
}

#Preview("Mock characters") {
    
    @Previewable @State var manager = CharacterManagerImpl(
        repository: CharacterServiceMock(
            characters: .mock
        )
    )
    
    TabbarView()
        .environment(manager)
        .environment(AppStateImpl())
}
