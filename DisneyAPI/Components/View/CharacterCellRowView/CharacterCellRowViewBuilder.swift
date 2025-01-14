//
//  CharacterCellRowViewBuilder.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 9/1/25.
//

import SwiftUI

struct CharacterCellRowViewBuilder<Content: View>: View {
    @Environment(\.isSearching) var isSearching
    
    @ViewBuilder var noSearchView: Content
    var previewSearchingView: (() -> Content)?
    var searchText: String
    @ViewBuilder var showListContent: AnyView
    
    var body: some View {
        List {
            // No searching
            if !isSearching {
                noSearchView
            } else {
                // Searching when click in searchbar, searchText empty
                if searchText.isEmpty {
                    if let previewSearch = previewSearchingView {
                        previewSearch()
                    } else {
                        noSearchView
                    }
                } else {
                    // Show list
                    showListContent
                }
            }
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
}

#Preview("Without Preview Searching View") {
    
    @Previewable @State var searchText: String = ""
    
    NavigationStack {
        CharacterCellRowViewBuilder(noSearchView: {
            Text("No Search View").toAnyView()
        }, searchText: searchText, showListContent: {
            Text("Show List Content").toAnyView()
        })
        .searchable(text: $searchText)
    }
}

#Preview("With Preview Searching View") {
    
    @Previewable @State var searchText: String = ""
    
    NavigationStack {
        CharacterCellRowViewBuilder(noSearchView: {
            Text("No Search View").toAnyView()
        }, previewSearchingView: {
            Text("Preview searching text").toAnyView()
        }, searchText: searchText, showListContent: {
            Text("Show List Content").toAnyView()
        })
        .searchable(text: $searchText)
    }
}

#Preview("Real case") {
    
    @Previewable @State var searchText: String = ""
    
    let characterManager = CharacterManagerImpl(
        repository: CharacterServiceImpl()
    )
    
    let viewModel = SearchViewModelImpl(
        interactor: CoreInteractor(
            characterManager: characterManager
        )
    )
    
    NavigationStack {
        SearchView(viewModel: viewModel)
            .task {
                await characterManager.getAllCharacters()
            }
            .searchable(text: $searchText, prompt: Text("search here..."))
    }
}

#Preview("Mock") {
    
    @Previewable @State var searchText: String = ""
    
    let characterManager = CharacterManagerImpl(
        repository: CharacterServiceMock(characters: .mock)
    )
    
    let viewModel = SearchViewModelImpl(
        interactor: CoreInteractor(
            characterManager: characterManager
        )
    )
    viewModel.searchCharacters(name: "queen")
    
    return NavigationStack {
        SearchView(viewModel: viewModel)
            .task {
                await characterManager.getAllCharacters()
            }
            .searchable(text: $searchText, prompt: Text("search here..."))
    }
}
