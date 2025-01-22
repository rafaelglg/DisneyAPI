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
                        email: "mail@gmail.com")
                }
                
                accountSection
                applicationSection
            }
            .navigationTitle("Profile")
        }
    }
    
    var accountSection: some View {
        
        Section {
            if viewModel.isAnonymous {
                Text("Sign In")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.00001))
                    .toAnyButton {
                        viewModel.updateViewState(showSignIn: true)
                    }
            }
            
            Text("Sign Out")
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white.opacity(0.00001))
                .toAnyButton {
                    viewModel.updateViewState(showTabBarView: false)
                }
            
            Text("Delete account")
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white.opacity(0.00001))
                .foregroundStyle(.red)
                .toAnyButton(action: viewModel.deleteAccount)
        } header: {
            Text("Account")
        }
    }
    
    var applicationSection: some View {
        
        Section {
            
            HStack {
                Text("Version")
                Spacer()
                Text("1.0")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Build Number")
                Spacer()
                Text("1")
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text("Application")
        } footer: {
            Text("Created by Rafael loggiodice.")
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
