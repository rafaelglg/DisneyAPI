//
//  ForgotPasswordView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 21/1/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State var viewModel: ForgotPasswordViewModelImpl
    var dismissForgotProcess: (() -> Void)?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack {
                VStack(alignment: .leading, spacing: 15) {
                    titleSection
                    secondaryInfoSection
                }
                .padding()
                
                emailSection
                buttonSection
            }
            .showCustomAlert(alert: $viewModel.showAlert)
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Image(systemName: "x.circle.fill")
                        .tint(.primary)
                        .toAnyButton { dismiss() }
                }
            }
        }
    }
    
    var titleSection: some View {
        Text("Forgot password?")
            .font(.largeTitle)
            .bold()
    }
    
    var secondaryInfoSection: some View {
        Text("Enter your email below, you will receive an email with instructions on how to reset your password in a few minutes")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    
    var emailSection: some View {
        CustomTexfield(text: $viewModel.email)
            .submitLabel(.send)
            .onSubmit {
                dismiss()
            }
    }
    
    var buttonSection: some View {
        Text("Send")
            .callToActionButton()
            .toAnyButton(option: .press, progress: viewModel.isLoading, action: viewModel.onSendPasswordReset)
            .padding()
            .navigationDestination(for: ForgotNavigationPath.self) { _ in
                ForgotSuccessView(
                    providedEmail: viewModel.email,
                    dismissForgotProcess: dismissForgotProcess
                )
            }
    }
}

#Preview {
    
    let container = DevPreview.shared.container
    
    ForgotPasswordView(
        viewModel: ForgotPasswordViewModelImpl(
            interactor: CoreInteractor(
                container: container
            )
        )
    )
}
