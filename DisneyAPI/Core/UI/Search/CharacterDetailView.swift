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
                    
                    PreviewLink(previewURL: sourceUrl)
                        .frame(width: 120)
                        .padding(.bottom, 120)
                    
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

#Preview("Mock") {
    @Previewable @State var character = CharacterDataResponse.mock
    CharacterDetailView(character: character)
}
