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
                searchText: viewModel.searchText,
                showListContent: {
                    showListView
                        .toAnyView()
                })
        }
        .searchable(text: $viewModel.searchText, isPresented: $viewModel.isActiveSearch, prompt: viewModel.promt)
        
        .navigationDestination(for: CharacterDataResponse.self) { character in
            Text(character.name ?? "")
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.searchCharacters(name: newValue)
        }
    }
    
    @ViewBuilder
    var noSearchingView: some View {
        if !viewModel.recentSearches.isEmpty {
            recentSearchesView
        } else {
            noRecentSearchesView
        }
    }
    
    @ViewBuilder
    var recentSearchesView: some View {
        HStack {
            Text("Recently searched")
                .font(.title2)
                .bold()
            
            Spacer()
            
            Text("clear")
                .font(.title3)
                .foregroundStyle(.link)
                .toAnyButton(option: .press) {
                    withAnimation(.easeOut.speed(0.5)) {
                        viewModel.onClearRecentSearches()
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.top, 30)
        .padding(.bottom, 10)
        .removeListRowFormatting()
        
        
        ForEach(viewModel.recentSearches, id: \.self) { search in
            Text(search)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.link)
                .background(Color.black.opacity(0.0001))
            
                .onTapGesture {
                    viewModel.isActiveSearch.toggle()
                    viewModel.searchText = search
                }
        }
    }
    
    var noRecentSearchesView: some View {
        ContentUnavailableView("No Recent Searches", systemImage: "binoculars.circle.fill", description: Text("Recent searches will be added as you search for characters"))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
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

#Preview("Production with recentSearches") {
    
    @Previewable @State var viewModel = SearchViewModelImpl(interactor: CoreInteractor(characterRepository: CharacterServiceImpl()))
    viewModel.recentSearches = ["mickey", "Minnie"]
    
    return NavigationStack {
        SearchView(viewModel: viewModel)
    }
}

#Preview("Mock") {
    NavigationStack {
        SearchView(viewModel: SearchViewModelImpl(interactor: CoreInteractor(characterRepository: CharacterServiceMock(characters: .mock))))
    }
}

#Preview("Mock with active search") {
    
    @Previewable @State var viewModel = SearchViewModelImpl(interactor: CoreInteractor(characterRepository: CharacterServiceMock(characters: .mock)))
    viewModel.isActiveSearch = true
    
    return NavigationStack {
        SearchView(viewModel: viewModel)
    }
}

#Preview("No found character") {
    
    @Previewable @State var viewModel = SearchViewModelImpl(interactor: CoreInteractor(characterRepository: CharacterServiceImpl()))
    viewModel.isActiveSearch = true
    viewModel.searchText = "Mickkk"
    viewModel.noSearchResult = true
    
    return NavigationStack {
        SearchView(viewModel: viewModel)
    }
}
