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
                .clipShape(.rect(cornerRadius: 15))
                .frame(width: 90, height: 120)
            nameText
        }
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
    
    let randomPicture: String = "https://picsum.photos/250"
    CharacterCellRowView(image: randomPicture, name: "name 2")
        .frame(width: 200, height: 120)
}

#Preview("Name w/out image") {
    
    CharacterCellRowView(name: "name 2")
        .frame(width: 200, height: 150)
}

#Preview("Image w/out name") {
    let randomPicture: String = "https://picsum.photos/700/700"
    CharacterCellRowView(image: randomPicture)
        .frame(width: 200, height: 150)
}

#Preview("W/out name and image") {
    CharacterCellRowView()
        .frame(width: 200, height: 150)
}
