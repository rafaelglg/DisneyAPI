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

protocol ForgotPasswordInteractor {
    
}

extension CoreInteractor: ForgotPasswordInteractor { }

@MainActor
@Observable
final class ForgotPasswordViewModelImpl {
    private let interactor: ForgotPasswordInteractor
    
    var email: String = ""
    var path: [ForgotNavigationPath] = []
    private(set) var isLoading: Bool = false
    
    init(interactor: ForgotPasswordInteractor) {
        self.interactor = interactor
    }
    
    func onChangeLoading(_ newValue: Bool) {
        isLoading = newValue
    }
    
}
