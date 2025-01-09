//
//  SearchView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import SwiftUI

struct SearchView: View {
    
    @State var viewModel: SearchViewModelImpl
    
    var body: some View {
        Group {
            CharacterCellRowViewBuilder(
                noSearchView: {
                    noSearchingView
                        .toAnyView()
                },
                previewSearchingView: {
                    searchingView
                        .toAnyView()
                },
                searchText: viewModel.searchText,
                isLoadingContent: viewModel.isLoading,
                showListContent: {
                    showListView
                        .toAnyView()
                })
        }
        .searchable(text: $viewModel.searchText, prompt: viewModel.promt)
        .navigationDestination(for: CharacterDataResponse.self) { character in
            Text(character.name ?? "")
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.searchCharacters(name: newValue)
        }
    }
    
    var noSearchingView: some View {
        Text("nothing here search")
            .removeListRowFormatting()
    }

    var searchingView: some View {
        Text("hola")
            .font(.headline)
            .bold()
            .removeListRowFormatting()
    }
    
    var showListView: some View {
        ForEach(viewModel.searchedCharacters) { character in
            NavigationLink(value: character) {
                CharacterCellRowView(
                    image: character.imageUrl,
                    name: character.name
                )
            }
        }
    }
}

#Preview("Production") {
    NavigationStack {
        SearchView(viewModel: SearchViewModelImpl(interactor: CoreInteractor(characterRepository: CharacterServiceImpl())))
    }
}

#Preview("Mock") {
    NavigationStack {
        SearchView(viewModel: SearchViewModelImpl(interactor: CoreInteractor(characterRepository: CharacterServiceMock(characters: .mock))))
    }
}

#Preview("Searching Text") {
    
    let viewModel = SearchViewModelImpl(interactor: CoreInteractor(characterRepository: CharacterServiceImpl()))
    viewModel.searchText = "Mickey"
    viewModel.searchCharacters(name: "Mickey")
    
    return NavigationStack {
        SearchView(viewModel: viewModel)
    }
}
