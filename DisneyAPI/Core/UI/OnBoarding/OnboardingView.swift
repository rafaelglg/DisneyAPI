//
//  OnboardingView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 12/1/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var viewModel: OnboardingViewModelImpl
    
    var body: some View {
        VStack(spacing: 8) {
            
            ImageLoaderView(urlString: viewModel.allCharacters.getFirstAndShuffled { $0.imageUrl
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
        .onAppear(perform: viewModel.loadCharacters)
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
                viewModel.updateViewState(showTabBarView: true)
                
                Task {
                    try? await Task.sleep(for: .seconds(1.2))
                    viewModel.updateViewState(showSignIn: true)
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
    
    let container = DevPreview.shared.container
    let manager = DisneyManagerImpl(repository: DisneyServiceImpl())
    container.register(DisneyManagerImpl.self, service: manager)
    
    let viewModel = OnboardingViewModelImpl(interactor: CoreInteractor(container: container))
    
     return OnboardingView(viewModel: viewModel)
}

#Preview("Mock image") {
    
    let container = DevPreview.shared.container
    
    OnboardingView(
        viewModel: OnboardingViewModelImpl(
            interactor: CoreInteractor(
                container: container
            )
        )
    )
}

#Preview("W/out image") {
    
    let container = DevPreview.shared.container
    let manager = DisneyManagerImpl(
        repository: DisneyServiceMock(
            characters: .emptyMock
        )
    )
    
    container.register(DisneyManagerImpl.self, service: manager)
    
    return OnboardingView(
        viewModel: OnboardingViewModelImpl(
            interactor: CoreInteractor(
                container: container
            )
        )
    )
}
