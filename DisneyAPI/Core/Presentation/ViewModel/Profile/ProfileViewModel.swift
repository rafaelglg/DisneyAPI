//
//  ProfileViewModel.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 17/1/25.
//

import Foundation
import SwiftUI

@MainActor
protocol ProfileViewModelInteractor {
    
    var user: UserAuthModel? { get }
    
    func updateViewState(showTabBarView: Bool)
    func updateViewState(showSignIn: Bool)
    func deleteAccount() async throws
    func signOut() async throws
    func reAuthenticateUser() async throws
    func getCurrentUser() throws -> UserAuthModel?
}

extension CoreInteractor: ProfileViewModelInteractor { }

@MainActor
@Observable
final class ProfileViewModel {
    private let interactor: ProfileViewModelInteractor
    
    private(set) var isDeletingUser: Bool = false
    
    var showAlert: AnyAppAlert?
    
    var user: UserAuthModel? {
        return interactor.user
    }
    
    var isAnonymous: Bool {
        return interactor.user?.isAnonymous ?? true
    }
    
    init(interactor: ProfileViewModelInteractor) {
        self.interactor = interactor
    }
    
    func onSignOut() {
        Task {
            do {
                try await interactor.signOut()
            } catch let error as NSError {
                let customError = CustomErrorMessage(errorDescription: error.getErrorMessage().errorMessage)
                showAlert = AnyAppAlert(error: customError)
            }
        }
    }
    
    func onDeleteAccountPressed() {
        showAlert = AnyAppAlert(
            title: "Delete Account?",
            subtitle: "This action is permanent and cannot be undone. Your data will be deleted from our server forever.",
            buttons: {
                AnyView(Button("Delete", role: .destructive, action: self.onDeleteAccountConfirmed))
        })
    }
    
    private func onDeleteAccountConfirmed() {
        isDeletingUser = true
        Task {
            do {
                try await interactor.deleteAccount()
                isDeletingUser = false
            } catch let error as NSError {
                let customError = CustomErrorMessage(errorDescription: error.getErrorMessage().errorMessage)
                isDeletingUser = false
                
                if error.getErrorMessage().errorType == .requiresRecentLogin {
                    showAlert = AnyAppAlert(
                        title: "Error",
                        subtitle: error.getErrorMessage().errorMessage) {
                            // needs to sign in again reauthenticate
                            AnyView(Button("Continue", action: self.reAuthenticateUser))
                        }
                } else {
                    showAlert = AnyAppAlert(error: customError)
                }
            }
        }
    }
    
    func reAuthenticateUser() {
        Task {
            do {
                try await interactor.reAuthenticateUser()
            } catch {
                print(error)
            }
        }
    }
    
    func updateViewState(showSignIn: Bool) {
        interactor.updateViewState(showSignIn: showSignIn)
    }
}
