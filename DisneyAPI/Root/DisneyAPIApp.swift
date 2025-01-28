//
//  DisneyAPIApp.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 6/1/25.
//

import SwiftUI
import FirebaseCore

@main
struct DisneyAPIApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AppView(
                viewModel: AppViewModel(
                    interactor: CoreInteractor(
                        container: delegate.dependencies.container
                    )
                )
            )
            .environment(delegate.dependencies.container)
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: Dependencies!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        dependencies = Dependencies()
        return true
    }
}
