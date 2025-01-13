//
//  TabbarView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 6/1/25.
//

import SwiftUI

struct TabbarView: View {
    
    @Environment(AppStateImpl.self) var appState
    @State var viewModel: SearchViewModelImpl
    
    var body: some View {
        @Bindable var appState = appState
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView(viewModel: viewModel)
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView(viewModel: viewModel)
            }
            
            Tab("Profile", systemImage: "person") {
                ProfileView()
            }
        }
        .sheet(isPresented: $appState.shouldPresentSignIn) {
            SignInView()
                .presentationDetents([.fraction(0.45)])
        }
    }
}

#Preview("Real characters") {
    
    @Previewable @State var viewModel = SearchViewModelImpl(
        interactor: CoreInteractor(characterRepository: CharacterServiceImpl()))
    
    TabbarView(viewModel: viewModel)
        .environment(AppStateImpl())
        .task {
            await viewModel.getAllCharacters()
        }
}

#Preview("Mock characters") {
    
    @Previewable @State var viewModel = SearchViewModelImpl(
        interactor: CoreInteractor(characterRepository: CharacterServiceMock(characters: .mock)))
    
    TabbarView(viewModel: viewModel)
        .environment(AppStateImpl())
}
