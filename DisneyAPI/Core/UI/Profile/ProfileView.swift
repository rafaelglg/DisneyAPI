//
//  ProfileView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 13/1/25.
//

import SwiftUI

struct ProfileView: View {
    
    @State var viewModel: ProfileViewModel
    
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.00001))
                    .toAnyButton {
                        viewModel.updateViewState(showSignIn: true)
                    }
                
                Text("Sign Out")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.00001))
                    .toAnyButton(role: .destructive) {
                        viewModel.updateViewState(showTabBarView: false)
                    }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    
    let container = DevPreview.shared.container
    
    ProfileView(
        viewModel: ProfileViewModel(
            interactor: CoreInteractor(
                container: container
            )
        )
    )        
}
