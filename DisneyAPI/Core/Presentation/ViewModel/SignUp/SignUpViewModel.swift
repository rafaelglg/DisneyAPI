//
//  SignUpInteractor.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 20/1/25.
//

import Foundation

@MainActor
protocol SignUpInteractor {
    func signUp(email: String, password: String) async throws -> UserAuthModel
    func logIn(user: UserModel) async throws
    func updateViewState(showSignIn: Bool)
}

extension CoreInteractor: SignUpInteractor { }

@MainActor
@Observable
final class SignUpViewModelImpl {
    
    private let interactor: SignUpInteractor
    
    var email: String = ""
    var fullName: String = ""
    var password: String = ""
    var showAlert: AnyAppAlert?
    private(set) var isloading: Bool = false
    
    init(interactor: SignUpInteractor) {
        self.interactor = interactor
    }
    
    func signUp() async {
        isloading = true
        
        defer { isloading = false }
        
        do {
            let user = try await interactor.signUp(email: email, password: password)
            try await interactor.logIn(user: user.toUserModel(fullname: fullName))
            interactor.updateViewState(showSignIn: false)
        } catch {
            print(error)
            showAlert = AnyAppAlert(error: error)
        }
    }
}
