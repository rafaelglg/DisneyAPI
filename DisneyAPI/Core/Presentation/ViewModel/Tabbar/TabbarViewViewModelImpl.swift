//
//  TabbarViewViewModelImpl.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 16/1/25.
//

@MainActor
protocol TabbarViewInteractor {
    var shouldPresentSignIn: Bool { get set }
    var currentUser: UserModel? { get }
}

extension CoreInteractor: TabbarViewInteractor { }

import SwiftUI

@MainActor
@Observable
final class TabbarViewViewModelImpl {
    private var interactor: TabbarViewInteractor
        
    var shouldPresentSignIn: Bool {
        get {
            interactor.shouldPresentSignIn
        } set {
            interactor.shouldPresentSignIn = newValue
        }
    }
    
    init(interactor: TabbarViewInteractor) {
        self.interactor = interactor
    }
}
