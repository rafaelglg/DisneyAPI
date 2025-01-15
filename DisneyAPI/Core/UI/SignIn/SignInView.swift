//
//  SignInView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 14/1/25.
//

import SwiftUI

struct SignInView: View {
    
    @Environment(CharacterManagerImpl.self) var characterManager
    @FocusState private var focusState: FieldState?
    @State private var showAlert: AnyAppAlert?
    
    var body: some View {
        ZStack {
            ScrollView {
                
                VStack(alignment: .leading) {
                    let array = characterManager.allCharacters.first(10)
                        .map { $0.imageUrl ?? "" }
                        .shuffled()
                    
                    ImageLoaderViewBuilder(
                        imageUrls: array,
                        animationDuration: 5.0,
                        animationType: .blurReplace(.upUp))
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
                    .clipShape(.rect(cornerRadius: 0))
                    .padding(.bottom)
                    
                    signInText
                    textfieldEmail
                    secureFieldPassword
                    buttonSection
                }
                // Tap background to hide keyboard
                .background(Color.black.opacity(0.001).onTapGesture {
                    hideKeyboard()
                })
                .showCustomAlert(alert: $showAlert)
            }
        }
    }
    
    private var signInText: some View {
        Text("Sign in")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    private var textfieldEmail: some View {
        TextField(text: .constant("")) {
            Text("Email")
                .bold()
        }
        .padding()
        .background(Color.init(hex: "F3F2F9"), in: RoundedRectangle(cornerRadius: 15))
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .textContentType(.emailAddress)
        .focused($focusState, equals: .email)
        .submitLabel(.continue)
        .onSubmit {
            focusState = .password
        }
        
    }
    
    private var secureFieldPassword: some View {
        SecureField(text: .constant("")) {
            Text("Password")
                .bold()
        }
        .textContentType(.password)
        .focused($focusState, equals: .password)
        .submitLabel(.done)
        
        .padding()
        .background(Color.init(hex: "F3F2F9"), in: RoundedRectangle(cornerRadius: 15))
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private var buttonSection: some View {
        Text("Continue")
            .callToActionButton()
            .padding(.horizontal)
            .toAnyButton {
                showAlert = AnyAppAlert(error: URLError(.badURL))
            }
    }
}

#Preview("Prod") {
    
    @Previewable @State var manager = CharacterManagerImpl(
        repository: CharacterServiceImpl()
    )
    
    return NavigationStack {
        
        if manager.isLoading {
            SignInView().redacted(reason: .placeholder).environment(manager)
        } else {
            SignInView()
                .environment(manager)
        }
    }
}

#Preview("Mock") {
    
    @Previewable @State var manager = CharacterManagerImpl(
        repository: CharacterServiceMock(
            characters: .mock, delay: 0.1
        )
    )
    
    return NavigationStack {
        
        if manager.isLoading {
            SignInView()
                .redacted(reason: .placeholder)
                .environment(manager)
        } else {
            SignInView()
                .environment(manager)
        }
    }
}
