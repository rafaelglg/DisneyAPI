//
//  ForgotPasswordInteractor.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 21/1/25.
//
import Foundation

enum ForgotNavigationPath: Hashable {
    case success
}

@MainActor
protocol ForgotPasswordInteractor {
    func sendPasswordReset(email: String) async throws
}

extension CoreInteractor: ForgotPasswordInteractor { }

@MainActor
@Observable
final class ForgotPasswordViewModelImpl {
    private let interactor: ForgotPasswordInteractor
    
    private(set) var isLoading: Bool = false
    
    var email: String = ""
    var user: UserAuthModel?
    var path: [ForgotNavigationPath] = []
    var showAlert: AnyAppAlert?
    
    init(interactor: ForgotPasswordInteractor) {
        self.interactor = interactor
    }
    
    func onSendPasswordReset() {
        isLoading = true
        
        Task {
            defer { isLoading = false }
            
            do {
                try await interactor.sendPasswordReset(email: email)
                path.append(.success)
            } catch let error as NSError {
                let customError = CustomErrorMessage(errorDescription: error.getErrorMessage())
                showAlert = AnyAppAlert(error: customError)
            }
        }
    }
}
