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
    
    var body: some Scene {
        WindowGroup {
            TabbarView(viewModel: viewModel)
        }
    }
}
