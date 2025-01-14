//
//  DisneyAPIApp.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 6/1/25.
//

import SwiftUI

@main
struct DisneyAPIApp: App {
    
    let characterManager: CharacterManagerImpl = CharacterManagerImpl(
        repository: CharacterServiceImpl()
    )
    let appState: AppStateImpl = AppStateImpl()
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .environment(appState)
        .environment(characterManager)
    }
}
