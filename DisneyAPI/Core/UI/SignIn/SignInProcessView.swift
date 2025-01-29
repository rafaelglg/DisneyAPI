//
//  SignInProcessView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 12/1/25.
//

import SwiftUI

struct SignInProcessView: View {
    
    @Environment(DependencyContainer.self) var container
    @Environment(\.dismiss) var dismiss
    
    @State var viewModel: SignInProcessViewModelImpl
        
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                
                titleText
                appleButton
                googleButton
                signInButton
            }
            .sheet(isPresented: $viewModel.showSignInView, onDismiss: onDismissSheet) {
                SignInView(
                    signInViewModel: SignInViewModelImpl(
                        interactor: CoreInteractor(
                            container: container
                        )
                    ), dismissProcessSheet: { viewModel.showSignInView(false) }
                )
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Image(systemName: "x.circle.fill")
                        .tint(.primary)
                        .toAnyButton { dismiss() }
                }
            }
        }
    }
    
    @ViewBuilder
    var titleText: some View {
        Text("Thanks for trying DisneyApi")
            .font(.title2)
            .bold()
        
        Text("Sign in or sign up to access for premium features that we provide")
            .minimumScaleFactor(0.8)
            .padding(.bottom)
    }
    
    var appleButton: some View {
        Text("Continue with Apple")
            .foregroundStyle(.white)
            .bold()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.primary, in: RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 30)
            .toAnyButton(option: .press) { }
    }
    
    var googleButton: some View {
        GoogleSignInButtonView {
            viewModel.signInWithGoogle(action: dismiss)
        }
            .padding(.horizontal, 30)
    }
    
    var signInButton: some View {
        Text("Sign in")
            .foregroundStyle(.white)
            .bold()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.red, in: RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 30)
            .toAnyButton(option: .press) {
                viewModel.showSignInView(true)
            }
    }
    
    private func onDismissSheet() {
        viewModel.shouldDismissView(action: dismiss)
    }
}

#Preview("Regular view") {
    @Previewable @State var manager = DisneyManagerImpl(
        repository: DisneyServiceMock(
            characters: .mock
        )
    )
    
    let container = DevPreview.shared.container
    
    SignInProcessView(viewModel: SignInProcessViewModelImpl(interactor: CoreInteractor(container: container)))
        .previewEnvironment()
}

#Preview("Sheet view") {
    
    @Previewable @State var manager = DisneyManagerImpl(
        repository: DisneyServiceMock(
            characters: .mock
        )
    )
    @Previewable @State var isSheetPresented: Bool = false
    let container = DevPreview.shared.container
    
    ZStack {
        if isSheetPresented {
            Color.black
                .opacity(0.4) // Nivel de oscurecimiento
                .ignoresSafeArea()
                .transition(.opacity)
        }
        VStack {
            Text("Demo view")
        }
    }
    .onAppear { isSheetPresented.toggle() }
    .sheet(isPresented: $isSheetPresented) {
        SignInProcessView(viewModel: SignInProcessViewModelImpl(interactor: CoreInteractor(container: container)))            .previewEnvironment()
            .presentationDetents([.fraction(0.5)])
        
    }
}
