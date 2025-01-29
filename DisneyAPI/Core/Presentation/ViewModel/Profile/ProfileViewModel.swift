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
                updateViewState(showTabBarView: false)
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
            AnyView(Button("Delete", role: .destructive) {
                self.onDeleteAccountConfirmed { [weak self] in
                    await self?.updateViewStateAsync(showTabBarView: false)
                }
            })
        })
    }
    
    private func onDeleteAccountConfirmed(_ goToOnboarding: @escaping () async -> Void) {
        isDeletingUser = true
        Task {
            do {
                try await interactor.deleteAccount()
                isDeletingUser = false
                await goToOnboarding()
            } catch let error as NSError {
                let customError = CustomErrorMessage(errorDescription: error.getErrorMessage().errorMessage)
                isDeletingUser = false
                
                if error.getErrorMessage().errorType == .requiresRecentLogin {
                    showAlert = AnyAppAlert(title: "Error", subtitle: error.getErrorMessage().errorMessage) {
                        AnyView(Button("Sign in") {
                            // needs to sign in again reauthenticate
                            self.reAuthenticateUser()
                        })
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
    
    func updateViewState(showTabBarView: Bool) {
        interactor.updateViewState(showTabBarView: showTabBarView)
    }
    
    private func updateViewStateAsync(showTabBarView: Bool) async {
        try? await Task.sleep(for: .seconds(0.1))
        interactor.updateViewState(showTabBarView: showTabBarView)
    }
    
    func updateViewState(showSignIn: Bool) {
        interactor.updateViewState(showSignIn: showSignIn)
    }
}
