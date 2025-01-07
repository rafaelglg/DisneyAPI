//
//  HeroCellView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import SwiftUI

struct HeroCellView: View {
    
    var title: String? = "This is some title"
    var subtitle: String? = "This is some subtitle that will go here."
    var imageName: String? = Constants.randomImage
    
    var body: some View {
        ZStack {
            if let imageName {
                ImageLoaderView(urlString: imageName, firstColor: .gray, secondColor: .black.opacity(0.4), thirdColor: .gray)
            } else {
                Rectangle()
                    .fill(.black)
            }
        }
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text(title)
                        .font(.headline)
                }
                
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                }
            }
            .foregroundStyle(.white)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .addingGradientBackgroundForText()
        }
        .cornerRadius(16)
    }
}

#Preview {
    HeroCellView()
        .frame(width: 300, height: 400)
}

#Preview("Cell with Title") {
    HeroCellView(title: "mock title", subtitle: "", imageName: "")
        .frame(width: 300, height: 400)
}

#Preview("Cell with Subtitle") {
    HeroCellView(title: "", subtitle: "Subtitle Mock", imageName: "")
        .frame(width: 300, height: 400)
}

#Preview("Cell with image") {
    HeroCellView(title: "", subtitle: "", imageName: Constants.randomImage)
        .frame(width: 300, height: 400)
}

#Preview("Empty hero cell") {
    HeroCellView(title: "", subtitle: "", imageName: "")
        .frame(width: 300, height: 400)
}
