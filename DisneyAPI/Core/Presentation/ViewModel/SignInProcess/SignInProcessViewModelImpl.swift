//
//  SignInProcessViewModelImpl.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 21/1/25.
//

import Foundation
import SwiftUI

@MainActor
protocol SignInProcessInteractor {
    var currentUser: UserModel? { get }
    func signInWithGoogle() async throws -> UserAuthModel
    func logIn(user: UserModel) async throws
}

extension CoreInteractor: SignInProcessInteractor { }

@MainActor
@Observable
final class SignInProcessViewModelImpl {
    private let interactor: SignInProcessInteractor
    
    var showSignInView: Bool = false
    
    init(interactor: SignInProcessInteractor) {
        self.interactor = interactor
    }
    
    func showSignInView(_ newValue: Bool) {
        showSignInView = newValue
    }
    
    func signInWithGoogle(action: DismissAction) {
        Task {
            do {
                let result = try await interactor.signInWithGoogle()
                try await interactor.logIn(user: result.toUserModel())
                action()
            } catch {
                print(error)
            }
        }
    }
    
    func shouldDismissView(action: DismissAction) {
        if interactor.currentUser?.isAnonymous == false {
            action()
        }
    }
}
