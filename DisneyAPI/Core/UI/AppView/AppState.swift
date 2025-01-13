//
//  AppState.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 13/1/25.
//

import Foundation

@Observable
final class AppStateImpl {
    
    private(set) var showTabBar: Bool = false
    private var showSignIn: Bool = false
    
    var shouldPresentSignIn: Bool {
        get {
            return showSignIn
        }
        set {
            showSignIn = newValue
        }
    }
    
    func updateViewState(showTabBarView: Bool) {
        self.showTabBar = showTabBarView
    }
    
    func updateViewState(showSignIn: Bool) {
        self.showSignIn = showSignIn
    }
}
