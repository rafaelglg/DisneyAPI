//
//  CarouselView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 11/1/25.
//

import SwiftUI

struct CarouselView<T: Hashable, Content: View>: View {
    
    var items: [T]
    @ViewBuilder var content: (T) -> Content
    @State private var selection: T?
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        content(item)
                            .scrollTransition(.interactive.threshold(.visible(0.95)), transition: { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1 : 0.9)
                            })
                            .containerRelativeFrame(.horizontal, alignment: .center)
                            .id(item)
                    }
                }
            }
            .frame(height: 200)
            .scrollIndicators(.hidden)
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $selection)
            .onChange(of: items.count, { _, _ in
                updateSelectionIfNeeded()
            })
            .onAppear {
                updateSelectionIfNeeded()
            }
            
            HStack(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Circle()
                        .fill(item == selection ? .blue : .secondary.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
            }
            .animation(.linear, value: selection)
        }
    }
    
    private func updateSelectionIfNeeded() {
        if selection == nil || selection == items.last {
            selection = items.first
        }
    }
}

#Preview("Mock") {
    CarouselView(items: CharacterDataResponse.dataResponseMock) { item in
        HeroCellView(
            title: item.name,
            subtitle: item.id.description,
            imageName: item.imageUrl
        )
    }
    .padding()
}

#Preview("Loading") {
    CarouselView(items: CharacterDataResponse.dataResponseMock) { item in
        HeroCellView(
            title: item.name,
            subtitle: item.id.description,
            imageName: item.imageUrl
        )
    }
    .redacted(reason: .placeholder)
    .padding()
}
