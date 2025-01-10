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
    // var isLoadingContent: Bool
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

#Preview("Production") {
    
    @Previewable @State var viewModel = SearchViewModelImpl(
        interactor: CoreInteractor(
            characterRepository: CharacterServiceImpl()
        )
    )
    NavigationStack {
        SearchView(viewModel: viewModel)
            .searchable(text: .constant(""), prompt: Text("search here..."))
    }
}

#Preview("Mock") {
    
    @Previewable @State var viewModel = SearchViewModelImpl(
        interactor: CoreInteractor(
            characterRepository: CharacterServiceMock(characters: .mock)
        )
    )
    NavigationStack {
        SearchView(viewModel: viewModel)
            .searchable(text: .constant(""), prompt: Text("search here..."))
    }
}
