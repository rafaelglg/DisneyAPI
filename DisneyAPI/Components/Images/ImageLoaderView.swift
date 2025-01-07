//
//  ImageLoaderView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//
import SwiftUI

struct ImageLoaderView: View {
    
    var urlString: String = Constants.randomImage
    
    var firstColor = Color(uiColor: UIColor.systemGray5)
    var secondColor: Color = Color(uiColor: UIColor.systemGray6)
    var thirdColor: Color = Color(uiColor: UIColor.systemGray5)
    
    var body: some View {
        VStack {
            customAsyncImage(urlString: urlString)
        }
    }
    
    private var placeholderImage: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3))
            .shimmerEffect(firstColor: firstColor, secondColor: secondColor, thirdColor: thirdColor)
            .clipShape(.rect(cornerRadius: 15))
    }
    
    @ViewBuilder
    func customAsyncImage(urlString: String) -> some View {
        if let url = URL(string: urlString) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            placeholderImage
                        case .success(let image):
                            image.resizable()
                                .scaledToFill()
                        case .failure:
                            Image(systemName: "exclamationmark.triangle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.red)
                        @unknown default:
                            placeholderImage
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
        } else {
            placeholderImage
        }
    }
}

#Preview("Correct image") {
    ImageLoaderView()
        .frame(width: 250, height: 400)
}

#Preview("w/out image") {
    ImageLoaderView(urlString: "")
        .frame(width: 100, height: 200)
}

#Preview("w/out image diffrent color") {
    ImageLoaderView(urlString: "", firstColor: .gray, secondColor: .black.opacity(0.4), thirdColor: .gray)
        .frame(width: 100, height: 200)
}
