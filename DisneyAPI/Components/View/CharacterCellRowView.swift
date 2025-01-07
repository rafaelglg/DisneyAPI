//
//  CharacterCellRowView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import SwiftUI

struct CharacterCellRowView: View {
    var image: String?
    var name: String?
    
    var body: some View {
        HStack {
            if let image, let url = URL(string: image) {
                customAsyncImage(placeholder: placeholderImage, image: url)
            } else {
                placeholderImage
            }
            nameText
        }
        .padding()
    }
    
    @ViewBuilder
    private var nameText: some View {
        if let name {
            Text(name)
                .font(.headline)
        } else {
            Text("Loading...")
                .font(.headline)
                .redacted(reason: .placeholder)
        }
    }
    
    private var placeholderImage: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 90, height: 120)
            .shimmerEffect()
            .clipShape(.rect(cornerRadius: 15))
    }
    
    func customAsyncImage(placeholder: some View, image: URL) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 90, height: 120)
            .overlay(
                
                AsyncImage(url: image) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                    default:
                        placeholderImage
                    }
                }
            )
            .clipped()
            .clipShape(.rect(cornerRadius: 15))
    }
}

#Preview("Image w/ name") {
    
    let randomPicture: String = "https://picsum.photos/700/700"
    CharacterCellRowView(image: randomPicture, name: "name 2")
}

#Preview("Name w/out image") {
    
    CharacterCellRowView(name: "name 2")
}

#Preview("Image w/out name") {
    let randomPicture: String = "https://picsum.photos/700/700"
    CharacterCellRowView(image: randomPicture)
}

#Preview("W/out name and image") {
    CharacterCellRowView()
}
