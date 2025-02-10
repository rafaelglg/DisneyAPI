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
                mainProfileSection
                accountSection
                applicationSection
            }
            .onAppear(perform: viewModel.loadUser)
            .onChange(of: viewModel.interactor.currentUser, viewModel.loadUser)
            .showCustomAlert(alert: $viewModel.showAlert)
            .navigationTitle("Profile")
        }
    }
    
    var mainProfileSection: some View {
        Section {
            if !viewModel.isAnonymous {
                SettingsRowCell(
                    profilePicture: viewModel.user?.profilePicture,
                    initials: viewModel.user?.initials,
                    fullName: viewModel.user?.fullName,
                    email: viewModel.user?.email)
            }
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
            } else {
                
                Text("Sign Out")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.00001))
                    .toAnyButton(action: viewModel.onSignOut)
            }
            
            deleteSection
        } header: {
            Text("Account")
        }
    }
    
    @ViewBuilder
    var deleteSection: some View {
        if viewModel.user?.isAnonymous == false {
            if viewModel.isDeletingUser {
                ProgressView()
            } else {
                Text("Delete account")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.00001))
                    .foregroundStyle(.red)
                    .toAnyButton(action: viewModel.onDeleteAccountPressed)
            }
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

#Preview("Is anonymous") {
    
    let container = DevPreview.shared.container
    let manager = AuthManagerImpl(repository: MockAuthService(selectMockUser: 1))
    container.register(AuthManagerImpl.self, service: manager)
    
    return ProfileView(
        viewModel: ProfileViewModel(
            interactor: CoreInteractor(
                container: container
            )
        )
    )
}

#Preview("User authenticated") {
    
    let container = DevPreview.shared.container
    
    ProfileView(
        viewModel: ProfileViewModel(
            interactor: CoreInteractor(
                container: container
            )
        )
    )
}
