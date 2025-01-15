//
//  CustomTexfield.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 15/1/25.
//

import SwiftUI

struct CustomTexfield: View {
    
    @Binding var text: String
    var prompt: String? = "Email"
    
    var body: some View {
        
        TextField(text: $text) {
            Text(prompt ?? "")
                .bold()
        }
        .padding()
        .background(Color.init(hex: "F3F2F9"), in: RoundedRectangle(cornerRadius: 15))
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .textInputAutocapitalization(.never)
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        .submitLabel(.continue)
    }
}

#Preview {
    
    @Previewable @State var text: String = ""
    CustomTexfield(text: $text)
}
