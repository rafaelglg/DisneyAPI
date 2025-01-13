//
//  AppView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 12/1/25.
//

import SwiftUI

struct AppView: View {
    
    let viewModel: SearchViewModelImpl
    @Environment(AppStateImpl.self) var appState
    
    var body: some View {
        ZStack {
            if appState.showTabBar {
                TabbarView(viewModel: viewModel)
                    .transition(.move(edge: .trailing))
            } else {
                OnboardingView(viewModel: viewModel)
                    .transition(.move(edge: .leading))
            }
        }
        .task {
            await viewModel.getAllCharacters()
        }
        .animation(.smooth, value: appState.showTabBar)
    }
}

#Preview {
    
    @Previewable @State var viewModel = SearchViewModelImpl(interactor: CoreInteractor(characterRepository: CharacterServiceMock(characters: .mock)))
    
    AppView(viewModel: viewModel)
        .environment(AppStateImpl())
        .task {
            await viewModel.getAllCharacters()
        }
}
