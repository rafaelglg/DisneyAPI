//
//  DisneyAPIApp.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 6/1/25.
//

import SwiftUI

@main
struct DisneyAPIApp: App {
    
    let viewModel = SearchViewModelImpl(
        interactor: CoreInteractor(characterRepository: CharacterServiceImpl()))
    let appState: AppStateImpl = AppStateImpl()
    
    var body: some Scene {
        WindowGroup {
            AppView(viewModel: viewModel)
        }
        .environment(appState)
    }
}
