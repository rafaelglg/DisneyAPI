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
        NavigationStack {
            List {
                disneyCharacterSection
            }
        }
    }
    
    @ViewBuilder
    var disneyCharacterSection: some View {
        let allCharacters = viewModel.allCharacters.shuffled().first(10)
        Section {
            if viewModel.isLoading {
                placeholderCell()
                    .frame(width: 350, height: 220)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .removeListRowFormatting()
            } else {
                CarouselView(items: allCharacters) { character in
                    HeroCellView(title: character.name, subtitle: nil, imageName: character.imageUrl)
                        .toAnyButton(option: .press) {
                            if let url = URL(string: character.sourceUrl ?? "") {
                                openURL(url)
                            }
                        }
                }
                .frame(width: 350, height: 220, alignment: .center)
                .frame(maxWidth: .infinity, alignment: .center)
                .removeListRowFormatting()
            }
        } header: {
            Text("Disney characters")
                .redacted(reason: allCharacters.isEmpty ? .placeholder : [])
        }
    }
    
    private func placeholderCell() -> some View {
        CarouselView(items: CharacterDataResponse.dataResponseMock) { _ in
            HeroCellView(title: Array(repeating: "", count: 4).description, subtitle: nil, imageName: "")
                .redacted(reason: .placeholder)
        }
    }
    
    private func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview("Production") {
    
    let viewModel = SearchViewModelImpl(
        interactor: CoreInteractor(characterRepository: CharacterServiceImpl()))
    
    NavigationStack {
        HomeView(viewModel: viewModel)
            .task {
                await viewModel.getAllCharacters()
            }
    }
}

#Preview("With mocks") {
    
    let viewModel = SearchViewModelImpl(
        interactor: CoreInteractor(characterRepository: CharacterServiceMock(characters: .mock)))
    
    NavigationStack {
        HomeView(
            viewModel: viewModel)
        .task {
            await viewModel.getAllCharacters()
        }
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
