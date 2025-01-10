//
//  CharacterDetailView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 10/1/25.
//

import SwiftUI

struct CharacterDetailView: View {
    
    let character: CharacterDataResponse
    
    var body: some View {
        ScrollView {
            VStack {
                
                ImageLoaderView(urlString: character.imageUrl ?? "")
                    .frame(width: UIScreen.main.bounds.height / 2, height: 600)
                
                characterName
                
                if let sourceUrl = character.sourceUrl, !sourceUrl.isEmpty {
                    Text("More info")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)
                        .padding(.top)
                    Link(destination: URL(string: sourceUrl)!) {
                        Text(sourceUrl)
                    }
                }
                
            }
        }
        .ignoresSafeArea()
    }
    
    private var characterName: some View {
        Text(character.name ?? "")
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 40)
            .padding(.top)
    }
}

#Preview("Production") {
    @Previewable @State var viewModel = SearchViewModelImpl(interactor: CoreInteractor(characterRepository: CharacterServiceImpl()))
    
    ZStack {
        if viewModel.isLoading {
            ProgressView()
        } else {
            CharacterDetailView(character: viewModel.allCharacters.first ?? .mock)
        }
    }
    .task {
        await viewModel.getAllCharacters()
    }
}

#Preview("Mock") {
    @Previewable @State var character = CharacterDataResponse.mock
    CharacterDetailView(character: character)
}
