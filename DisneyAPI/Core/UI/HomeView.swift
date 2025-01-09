//
//  HomeView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import SwiftUI

struct HomeView: View {
    
    @State var viewModel: SearchViewModelImpl
    
    var body: some View {
        VStack {
            
            HeroCellView()
            
            List {
                if viewModel.isLoading {
                    placeholderCell
                    
                } else {
                    ForEach(viewModel.allCharacters) { character in
                        NavigationLink(value: character) {
                            CharacterCellRowView(
                                image: character.imageUrl,
                                name: character.name
                            )
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.getAllCharacters()
        }
        .navigationDestination(for: CharacterDataResponse.self) { character in
            Text(character.name ?? "")
        }
    }
    
    private var placeholderCell: some View {
        ForEach(CharacterDataResponse.dataResponseMock) { _ in
            CharacterCellRowView(
                image: nil,
                name: "Placeholder name for redacted"
            )
            .redacted(reason: .placeholder)
        }
    }
}

#Preview("With mocks") {
    NavigationStack {
        HomeView(
            viewModel: SearchViewModelImpl(
                interactor: CoreInteractor(characterRepository: CharacterServiceMock(characters: .mock))))
    }
}

#Preview("Empty cell") {
    NavigationStack {
        HomeView(
            viewModel: SearchViewModelImpl(
                interactor: CoreInteractor(characterRepository: CharacterServiceMock(characters: .emptyMock))))
    }
}

#Preview("Cell with delay") {
    NavigationStack {
        HomeView(
            viewModel: SearchViewModelImpl(
                interactor: CoreInteractor(characterRepository: CharacterServiceMock(characters: .mock, delay: 3.0))))
    }
}
