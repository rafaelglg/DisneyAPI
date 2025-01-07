//
//  ShimmerEffect.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import SwiftUI

struct ShimmerEffect: ViewModifier {
    
    var firstColor: Color
    var secondColor: Color
    var thirdColor: Color
    
    @State var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State var endPoint: UnitPoint = .init(x: 0, y: -0.2)
    
    func body(content: Content) -> some View {
        content
            .overlay {
                LinearGradient(
                    colors: [
                        firstColor,
                        secondColor,
                        thirdColor
                    ],
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 1)
                        .repeatForever(autoreverses: false)
                    ) {
                        startPoint = .init(x: 1, y: 1)
                        endPoint = .init(x: 2.2, y: 2.2)
                    }
                }
            }
    }
}

#Preview("Default color gray") {
    Rectangle()
        .frame(width: 240, height: 280)
        .shimmerEffect()
        .clipShape(.rect(cornerRadius: 15))
}

#Preview("Diffrent color") {
    RoundedRectangle(cornerRadius: 10)
        .frame(width: 240, height: 280)
        .shimmerEffect(firstColor: .yellow, secondColor: .red, thirdColor: .yellow)
        .clipShape(.rect(cornerRadius: 15))
}

extension View {
    func shimmerEffect(
        firstColor: Color = Color(uiColor: UIColor.systemGray5),
        secondColor: Color = Color(uiColor: UIColor.systemGray6),
        thirdColor: Color = Color(uiColor: UIColor.systemGray5)
    ) -> some View {
        self.modifier(
            ShimmerEffect(
                firstColor: firstColor,
                secondColor: secondColor,
                thirdColor: thirdColor
            )
        )
    }
}
