//
//  AppViewModel.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 16/1/25.
//

import Foundation

@MainActor
protocol AppViewInteractor {
    var showTabBar: Bool { get }
    var shouldPresentSignIn: Bool { get }
    var user: UserAuthModel? { get }
    
    func updateViewState(showTabBarView: Bool)
    func signInAnonymously() async throws -> UserAuthModel
}

extension CoreInteractor: AppViewInteractor { }

@MainActor
@Observable
final class AppViewModel {
 
    let interactor: AppViewInteractor
    
    var showTabBar: Bool {
        interactor.showTabBar
    }
    
    var showSignIn: Bool {
        return interactor.shouldPresentSignIn
    }
    
    init(interactor: AppViewInteractor) {
        self.interactor = interactor
    }
    
    func checkUserStatus() {
        if let user = interactor.user {
            // user is authenticated
            
            print(user)
            print("tiene usuario")
        } else {
            print("Es usuario anonimo")
            Task {
                do {
                    let result = try await interactor.signInAnonymously()
                    print("Sign in anonymous success: \(result.id)")
                } catch {
                    print("error sign in anonymous")
                }
            }
        }
    }
}
