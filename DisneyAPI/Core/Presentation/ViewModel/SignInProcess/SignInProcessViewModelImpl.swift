//
//  SignInProcessViewModelImpl.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 21/1/25.
//

import Foundation

@MainActor
protocol SignInProcessInteractor {
    var user: UserAuthModel? { get }
}

extension CoreInteractor: SignInProcessInteractor { }

@MainActor
@Observable
final class SignInProcessViewModelImpl {
    private let interactor: SignInProcessInteractor
    private(set) var user: UserAuthModel?
    
    var showSignInView: Bool = false
    
    init(interactor: SignInProcessInteractor) {
        self.interactor = interactor
    }
    
    func getCurrentUser() -> UserAuthModel? {
        user = interactor.user
        return user
    }
    
    func showSignInView(_ newValue: Bool) {
        showSignInView = newValue
    }
    
}
