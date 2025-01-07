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
            ImageLoaderView(urlString: image ?? "")
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
