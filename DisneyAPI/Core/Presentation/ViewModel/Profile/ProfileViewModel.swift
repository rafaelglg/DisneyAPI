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
}

extension CoreInteractor: ProfileViewModelInteractor { }

@MainActor
@Observable
final class ProfileViewModel {
    private let interactor: ProfileViewModelInteractor
    
    init(interactor: ProfileViewModelInteractor) {
        self.interactor = interactor
    }
    
    func updateViewState(showTabBarView: Bool) {
        interactor.updateViewState(showTabBarView: showTabBarView)
    }
    
    func updateViewState(showSignIn: Bool) {
        interactor.updateViewState(showSignIn: showSignIn)
    }
}
