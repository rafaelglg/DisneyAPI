//
//  SignUpInteractor.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 20/1/25.
//

import Foundation

@MainActor
protocol SignUpInteractor {
    func signUp(email: String, password: String) async throws
}

extension CoreInteractor: SignUpInteractor { }

@MainActor
@Observable
final class SignUpViewModelImpl {
    
    private let interactor: SignUpInteractor
    
    var email: String = ""
    var fullName: String = ""
    var password: String = ""
    private(set) var isloading: Bool = false
    
    init(interactor: SignUpInteractor) {
        self.interactor = interactor
    }
    
    func signUp() {
        Task {
            do {
                try await interactor.signUp(email: email, password: password)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func onChangeLoading(_ newValue: Bool) {
        isloading = newValue
    }
}
