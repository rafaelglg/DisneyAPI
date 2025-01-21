//
//  ImageLoaderViewBuilder.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 14/1/25.
//

import SwiftUI

struct ImageLoaderViewBuilder<AnimationType: Transition>: View {
    @Binding var imageUrls: [String]
    
    @State var animationDuration: Double = 7.0
    @State var animationType: AnimationType
    
    @State private var currentImageIndex: Int = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            if !imageUrls.isEmpty {
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
        timer = Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) {_ in
            Task { @MainActor in
                withAnimation(.easeInOut(duration: animationDuration)) {
                    loopingImage()
                }
            }
        }
    }
    
    private var placeholderImage: some View {
        ImageLoaderView(urlString: "")
            .redacted(reason: .placeholder)
    }
    
    private func loopingImage() {
        guard !imageUrls.isEmpty else {
            return
        }
        currentImageIndex = (currentImageIndex + 1) % imageUrls.count
    }
}

#Preview("Animating image") {
    ImageLoaderViewBuilder(
        imageUrls: .constant(Array(repeating: Constants.randomImage, count: 5)),
        animationDuration: 3.0,
        animationType: .blurReplace(.upUp)
    )
    .frame(width: 300, height: 450)
    .clipShape(.rect(cornerRadius: 15))
}

#Preview("Animating image with delay") {
    @Previewable @State var array: [String] = []
    
    return ImageLoaderViewBuilder(
        imageUrls: $array,
        animationDuration: 3.0,
        animationType: .blurReplace(.upUp)
    )
    .task {
        try? await Task.sleep(for: .seconds(1.0))
        array = Array(repeating: Constants.randomImage, count: 5)
    }
    .frame(width: 300, height: 450)
    .clipShape(.rect(cornerRadius: 15))
}

#Preview("Without image") {
    ImageLoaderViewBuilder(
        imageUrls: .constant([""]),
        animationDuration: 5.0,
        animationType: .blurReplace(.upUp)
    )
    .frame(width: 300, height: 450)
    .clipShape(.rect(cornerRadius: 15))
}

#Preview("Empty value") {
    ImageLoaderViewBuilder(
        imageUrls: .constant([]),
        animationDuration: 5.0,
        animationType: .blurReplace(.upUp)
    )
    .frame(width: 300, height: 450)
    .clipShape(.rect(cornerRadius: 15))
}
