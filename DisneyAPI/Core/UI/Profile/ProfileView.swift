//
//  ProfileView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 13/1/25.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(AppStateImpl.self) var appState
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    SettingsRowCell(
                        initials: "RL",
                        fullName: "Rafael loggiodice",
                        email: "mail@gmail.com") {
                        Text("hola")
                    }
                }
                
                Text("Sign In")
                    .toAnyButton {
                        appState.updateViewState(showSignIn: true)
                    }
                
                Text("Sign Out")
                    .toAnyButton(role: .destructive) {
                        appState.updateViewState(showTabBarView: false)
                    }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
        .environment(AppStateImpl())
}
