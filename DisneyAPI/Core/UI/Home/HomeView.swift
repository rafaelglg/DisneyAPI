//
//  HomeView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(AppStateImpl.self) var appState
    @Environment(CharacterManagerImpl.self) var characterManager
    
    var body: some View {
        NavigationStack {
            List {
                disneyCharacterSection
            }
        }
    }
    
    @ViewBuilder
    var disneyCharacterSection: some View {
        let allCharacters = characterManager.allCharacters.shuffled().first(10)
        Section {
            if characterManager.isLoading {
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
    
    let characterManager = CharacterManagerImpl(
        repository: CharacterServiceImpl()
    )
    
    NavigationStack {
        HomeView()
            .environment(characterManager)
            .environment(AppStateImpl())
    }
}

#Preview("With mocks") {
    
    let characterManager = CharacterManagerImpl(
        repository: CharacterServiceMock(characters: .mock)
    )
    
    NavigationStack {
        HomeView()
        .environment(characterManager)
        .environment(AppStateImpl())
    }
}

#Preview("Empty cell") {
    
    let characterManager = CharacterManagerImpl(
        repository: CharacterServiceMock(characters: .emptyMock)
    )
    
    NavigationStack {
        HomeView()
            .environment(characterManager)
            .environment(AppStateImpl())
    }
}

#Preview("Cell with delay") {
    
    let characterManager = CharacterManagerImpl(
        repository: CharacterServiceMock(characters: .mock, delay: 3.0)
    )
    
    NavigationStack {
        HomeView()
        .environment(characterManager)
        .environment(AppStateImpl())
    }
}
