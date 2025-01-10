//
//  TabbarView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 6/1/25.
//

import SwiftUI

struct TabbarView: View {
    
    @State var viewModel: SearchViewModelImpl
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView(viewModel: viewModel)
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView(viewModel: viewModel)
            }
            
            Tab("Profile", systemImage: "person") {
                NavigationStack {
                    Text("Profile")
                }
            }
        }
        .task {
            await viewModel.getAllCharacters()
        }
    }
}

#Preview("Real characters") {
    
    @Previewable @State var viewModel = SearchViewModelImpl(
        interactor: CoreInteractor(characterRepository: CharacterServiceImpl()))
    
    TabbarView(viewModel: viewModel)
        .task {
            await viewModel.getAllCharacters()
        }
}

#Preview("Mock characters") {
    
    @Previewable @State var viewModel = SearchViewModelImpl(
        interactor: CoreInteractor(characterRepository: CharacterServiceMock(characters: .mock)))
    
    TabbarView(viewModel: viewModel)
}
