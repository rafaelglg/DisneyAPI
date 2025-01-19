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
    var textContentType: UITextContentType = .emailAddress
    
    var body: some View {
        
        TextField(text: $text) {
            Text(prompt ?? "")
                .bold()
        }
        .frame(height: 54)
        .padding(.horizontal)
        .background(.textfieldBackground, in: RoundedRectangle(cornerRadius: 15))
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .textInputAutocapitalization(.never)
        .keyboardType(.emailAddress)
        .textContentType(textContentType)
        .submitLabel(.continue)
        .padding(.vertical)
    }
}

#Preview() {
    
    @Previewable @State var text: String = ""
    @Previewable @State var fullName: String = ""
    CustomTexfield(text: $text)
    CustomTexfield(
        text: $fullName,
        prompt: "Jane doe",
        textContentType: .name
    )
}
