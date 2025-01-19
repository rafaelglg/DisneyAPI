//
//  HomeView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import SwiftUI

struct HomeView: View {
    
    @State var viewModel: HomeViewModelImpl
    
    var body: some View {
        NavigationStack {
            List {
                disneyCharacterSection
            }
            .onAppear(perform: viewModel.refreshCharacters)
            .onChange(of: viewModel.interactor.allCharacters) { _, newValue in
                viewModel.getCharacters(newValue)
            }
        }
    }
    
    @ViewBuilder
    var disneyCharacterSection: some View {
        let allCharacters = viewModel.allCharacters
        Section {
            if viewModel.isLoading {
                placeholderCell
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
    
    private var placeholderCell: some View {
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
    
    let manager = CharacterManagerImpl(
        repository: CharacterServiceImpl()
    )
    
    let container = DevPreview.shared.container
    container.register(CharacterManagerImpl.self, service: manager)
    let vmodel = HomeViewModelImpl(interactor: CoreInteractor(container: container))
    _ = vmodel.allCharacters.first(2)
    
    return NavigationStack {
        HomeView(viewModel: vmodel)
            .task(manager.getAllCharacters)
    }
}

#Preview("With mocks") {
    
    let container = DevPreview.shared.container
    let manager = CharacterManagerImpl(repository: CharacterServiceMock(characters: .mock, delay: 0.1))
    container.register(CharacterManagerImpl.self, service: manager)
    let viewModel = HomeViewModelImpl(interactor: CoreInteractor(container: container))
    
    return NavigationStack {
        HomeView(viewModel: viewModel)
            .task {
                await manager.getAllCharacters()
            }
    }
}

#Preview("Empty cell") {
    
    let manager = CharacterManagerImpl(
        repository: CharacterServiceMock(characters: .emptyMock)
    )
    
    let container = DevPreview.shared.container
    container.register(CharacterManagerImpl.self, service: manager)
    
    return NavigationStack {
        HomeView(viewModel: HomeViewModelImpl(interactor: CoreInteractor(container: container)))
    }
}

#Preview("Cell with delay") {
    
    let manager = CharacterManagerImpl(
        repository: CharacterServiceMock(characters: .mock, delay: 3.0)
    )
    
    let container = DevPreview.shared.container
    container.register(CharacterManagerImpl.self, service: manager)
    
    return NavigationStack {
        HomeView(
            viewModel: HomeViewModelImpl(
                interactor: CoreInteractor(
                    container: container
                )
            )
        )
        .task {
            await manager.getAllCharacters()
        }
    }
}
