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
    var showAlert: AnyAppAlert?
    private(set) var isloading: Bool = false
    private(set) var dismissProcessSheet: (() -> Void)?
    
    init(interactor: SignUpInteractor) {
        self.interactor = interactor
    }
    
    func signUp() async {
        isloading = true
        
        defer { isloading = false }
        
        do {
            try await Task.sleep(for: .seconds(4))
            dismissProcessSheet?()
        } catch {
            showAlert = AnyAppAlert(error: error)
        }
    }
    
    func onChangeDismissProccessSheet(_ newValue: (() -> Void)?) {
        dismissProcessSheet = newValue
    }
}
