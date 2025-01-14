//
//  OnboardingView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 12/1/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(CharacterManagerImpl.self) var characterManager
    @Environment(AppStateImpl.self) var appState
    
    var body: some View {
        VStack(spacing: 8) {
            ImageLoaderView(urlString: characterManager.allCharacters.getFirstAndShuffled { $0.imageUrl
            } ?? "")
            .drawingGroup()
            .ignoresSafeArea()
            
            titleSection
                .padding(.top, 24)
            ctaButtons
                .padding(.top, 18)
            policyLinks
                .padding(.vertical, 20)
        }
    }
    
    var titleSection: some View {
        VStack(spacing: 8) {
            Text("Disney Api")
                .font(.largeTitle)
                .bold()
            
            Text("Rafael Loggiodice")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    var ctaButtons: some View {
        
        Text("Get started")
            .callToActionButton()
            .padding(.horizontal)
            .toAnyButton {
                appState.updateViewState(showTabBarView: true)
                Task {
                    try? await Task.sleep(for: .seconds(1))
                    appState.updateViewState(showSignIn: true)
                }
            }
    }
    
    private var policyLinks: some View {
        HStack(spacing: 8) {
            Link(destination: URL(string: Constants.termsOfServiceUrl)!) {
                Text("Terms of Service")
                    .tint(.red)
            }
            Circle()
                .fill(.red)
                .frame(width: 4, height: 4)
            Link(destination: URL(string: Constants.privacyPolicyUrl)!) {
                Text("Privacy Policy")
                    .tint(.red)
            }
        }
    }
}

#Preview("With image") {
    
    @Previewable @State var appState = AppStateImpl()
    
    let characterManager = CharacterManagerImpl(
        repository: CharacterServiceImpl()
    )
    OnboardingView()
        .environment(characterManager)
        .environment(appState)
        .task {
            await characterManager.getAllCharacters()
        }
}

#Preview("W/out image") {
    
    @Previewable @State var appState = AppStateImpl()
    
    let characterManager = CharacterManagerImpl(
        repository: CharacterServiceMock(characters: .emptyMock)
    )
    OnboardingView()
        .environment(characterManager)
        .environment(appState)
        .task {
            await characterManager.getAllCharacters()
        }
}
