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
    
    @ViewBuilder
    var showListView: some View {
        
        if viewModel.isLoading {
            placeholderListCell
        } else if viewModel.noSearchResult {
            noSearchResultView
        } else {
            listView
        }
    }
    
    private var placeholderListCell: some View {
        ForEach(CharacterDataResponse.dataResponseMock) { _ in
            CharacterCellRowView(
                image: nil,
                name: "Placeholder name for redacted"
            )
            .redacted(reason: .placeholder)
        }
    }
    
    private var noSearchResultView: some View {
        ContentUnavailableView(
            "No characters found",
            systemImage: "binoculars.circle.fill",
            description: Text("No found for the character ''\(viewModel.searchText)''"))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.2, alignment: .center)
        .removeListRowFormatting()
    }
    
    private var listView: some View {
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

#Preview("No found character") {
    
    @Previewable @State var viewModel = SearchViewModelImpl(interactor: CoreInteractor(characterRepository: CharacterServiceImpl()))
    viewModel.searchText = "Click here"
    viewModel.noSearchResult = true
    
    return NavigationStack {
        SearchView(viewModel: viewModel)
    }
}
