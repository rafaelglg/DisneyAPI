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
        VStack {
            ImageLoaderView(urlString: character.imageUrl ?? "")
                .frame(width: 200, height: 300)
            
            Text(character.name ?? "")
                .font(.title2)
                .bold()
 
        }
    }
}

#Preview("Production") {
    @Previewable @State var viewModel = SearchViewModelImpl(interactor: CoreInteractor(characterRepository: CharacterServiceImpl()))
    
    VStack {
        CharacterDetailView(character: viewModel.allCharacters.first ?? .mock)
            .task {
                await viewModel.getAllCharacters()
            }
    }
}

#Preview("Mock") {
    @Previewable @State var character = CharacterDataResponse.mock
    CharacterDetailView(character: character)
}
