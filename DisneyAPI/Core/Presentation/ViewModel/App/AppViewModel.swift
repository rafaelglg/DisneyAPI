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
}
