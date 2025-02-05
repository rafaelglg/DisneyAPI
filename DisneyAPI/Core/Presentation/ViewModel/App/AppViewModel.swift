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
    var userAuth: UserAuthModel? { get }
    
    func updateViewState(showTabBarView: Bool)
    func signInAnonymously() async throws -> UserAuthModel
    func logIn(user: UserModel) async throws
    func getCurrentUser(userId: String) async throws -> UserModel
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
        if let user = interactor.userAuth {
            // user is authenticated
            Task {
                do {
                    let dbUser = try await interactor.getCurrentUser(userId: user.id)
                    print(dbUser)
                    print("tiene usuario")
                    try await interactor.logIn(user: dbUser)
                } catch {
                    print(error)
                    checkUserStatus()
                }
            }
        } else {
            print("Es usuario anonimo")
            Task {
                do {
                    let result = try await interactor.signInAnonymously()
                    try await interactor.logIn(user: result.toUserModel())
                    print("Sign in anonymous success: \(result.id)")
                } catch {
                    print("error sign in anonymous")
                }
            }
        }
    }
}
