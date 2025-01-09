//
//  TabbarView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 6/1/25.
//

import SwiftUI

struct TabbarView: View {
    
    @State var characterServiceImpl: CharacterService = CharacterServiceImpl()
    
    var body: some View {
        
            TabView {
                
                Tab("Home", systemImage: "house") {
                    NavigationStack {
                        HomeView(viewModel: SearchViewModelImpl(interactor: CoreInteractor(characterRepository: characterServiceImpl)))
                    }
                }
                
                Tab("Search", systemImage: "magnifyingglass") {
                    NavigationStack {
                        SearchView(viewModel: SearchViewModelImpl(interactor: CoreInteractor(characterRepository: characterServiceImpl)))
                    }
                }
                
                Tab("Profile", systemImage: "person") {
                    NavigationStack {
                        Text("Profile")
                    }
                
            }
        }
    }
}

#Preview("Real characters") {
    TabbarView()
}

#Preview("Mock characters") {
    TabbarView(characterServiceImpl: CharacterServiceMock(characters: .mock))
}
