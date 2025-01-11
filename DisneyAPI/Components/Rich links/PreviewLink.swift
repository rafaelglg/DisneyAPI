//
//  PreviewLink.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 11/1/25.
//

import SwiftUI
import LinkPresentation

final class CustomLinkView: LPLinkView {
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: super.intrinsicContentSize.height)
    }
}

@MainActor
struct PreviewLink: UIViewRepresentable {
    var previewURL: String
    
    func makeUIView(context: Context) -> CustomLinkView {
        
        if let url = URL(string: previewURL) {
            
            let linkPreview = CustomLinkView(url: url)
            let provider = LPMetadataProvider()
            
            Task {
                do {
                    let metadata = try await provider.startFetchingMetadata(for: url)
                    linkPreview.metadata = metadata
                    linkPreview.sizeToFit()
                } catch {
                    print(error)
                }
            }
            
            linkPreview.sizeToFit()
            return linkPreview
        }
        
        return CustomLinkView()
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: LPLinkView, context: Context) -> CGSize? {
        // The proposed width is the containing frame's width, if one is available use that width,
        // otherwise fallback to the custom view's intrinsic width
        let width = proposal.width ?? uiView.intrinsicContentSize.width

        // The proposed height is the containing frame's height which is going to be way to big.
        // So use the view's intrinsic height otherwise fallback to the smallest.
        let height = min(proposal.height ?? .infinity, uiView.intrinsicContentSize.height)
        return CGSize(width: width, height: height)
    }
    
    func updateUIView(_ uiView: CustomLinkView, context: Context) {}
}

#Preview {
    
    VStack {
        PreviewLink(previewURL: "https://apple.com")
        
        PreviewLink(previewURL: "https://spotify.com")
    }
    .frame(height: 50)
    .padding()
    .frame(maxWidth: .infinity)
    .ignoresSafeArea()
}

extension LPLinkMetadata: @unchecked @retroactive Sendable { }
