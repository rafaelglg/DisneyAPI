//
//  ProfileViewModel.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 17/1/25.
//

import Foundation

@MainActor
protocol ProfileViewModelInteractor {
    func updateViewState(showTabBarView: Bool)
    func updateViewState(showSignIn: Bool)
    var user: UserAuthModel? { get }
}

extension CoreInteractor: ProfileViewModelInteractor { }

@MainActor
@Observable
final class ProfileViewModel {
    private let interactor: ProfileViewModelInteractor
    
    private(set) var user: UserAuthModel?
    
    init(interactor: ProfileViewModelInteractor) {
        self.interactor = interactor
        getCurrentUser()
    }
    
    var isAnonymous: Bool {
        true
    }
    
    func getCurrentUser() {
        user = interactor.user
    }
    
    func deleteAccount() {
        
        updateViewState(showTabBarView: true)
    }
    
    func updateViewState(showTabBarView: Bool) {
        interactor.updateViewState(showTabBarView: showTabBarView)
    }
    
    func updateViewState(showSignIn: Bool) {
        interactor.updateViewState(showSignIn: showSignIn)
    }
}
