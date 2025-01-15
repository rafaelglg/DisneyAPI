//
//  ImageLoaderViewBuilder.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 14/1/25.
//

import SwiftUI

struct ImageLoaderViewBuilder<AnimationType: Transition>: View {
    @State var imageUrls: [String]?
    
    @State var animationDuration: Double = 7.0
    @State var animationType: AnimationType
    
    @State private var currentImageIndex: Int = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            if let imageUrls, !imageUrls.isEmpty {
                ImageLoaderView(
                    urlString: imageUrls[currentImageIndex]
                )
                .id(currentImageIndex) // To force the change of image
                .transition(animationType) // Type of animation used
            } else {
                placeholderImage
            }
        }
        .onDisappear(perform: stopImageRotation)
        .onAppear(perform: startImageRotation)
    }
    
    private func stopImageRotation() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startImageRotation() {
        
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: animationDuration)) {
                loopingImage()
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    loopingImage()
                }
            }
        }
    }
    
    var placeholderImage: some View {
        ImageLoaderView(urlString: "")
            .redacted(reason: .placeholder)
    }
    
    func loopingImage() {
        guard let imageUrls, !imageUrls.isEmpty else { return }
        
        // infinite loop: currentImageIndex + 1 = 1+1 % 2 = 0
        currentImageIndex = (currentImageIndex + 1) % imageUrls.count
    }
}

#Preview("Animating image") {
    ImageLoaderViewBuilder(
        imageUrls: Array(repeating: Constants.randomImage, count: 5),
        animationDuration: 3.0,
        animationType: .blurReplace(.upUp)
    )
    .frame(width: 300, height: 450)
    .clipShape(.rect(cornerRadius: 15))
}

#Preview("Without image") {
    ImageLoaderViewBuilder(
        imageUrls: [""],
        animationDuration: 5.0,
        animationType: .blurReplace(.upUp)
    )
    .frame(width: 300, height: 450)
    .clipShape(.rect(cornerRadius: 15))
}

#Preview("Empty value") {
    ImageLoaderViewBuilder(
        imageUrls: [],
        animationDuration: 5.0,
        animationType: .blurReplace(.upUp)
    )
    .frame(width: 300, height: 450)
    .clipShape(.rect(cornerRadius: 15))
}
