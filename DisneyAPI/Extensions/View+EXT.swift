//
//  View + Ext.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import SwiftUI

extension View {
    func removeListRowFormatting() -> AnyView {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .toAnyView()
    }
    
    func addingGradientBackgroundForText() -> some View {
        background(
            LinearGradient(colors: [
                Color.black.opacity(0),
                Color.black.opacity(0.3),
                Color.black.opacity(0.5)
            ], startPoint: .top, endPoint: .bottom)
        )
    }
    
    func toAnyView() -> AnyView {
        AnyView(self)
    }
    
    func callToActionButton(backgroundColor: Color? = nil, role: ButtonRole? = nil) -> some View {
        self
            .font(.headline)
            .foregroundStyle(role == .destructive ? .red : .white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(backgroundColor ?? .red, in: RoundedRectangle(cornerRadius: 16))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
