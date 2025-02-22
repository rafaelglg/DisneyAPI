//
//  AppView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 12/1/25.
//

import SwiftUI

struct AppView: View {
    
    @Environment(DependencyContainer.self) var container
    @State var viewModel: AppViewModel
    
    var body: some View {
        ZStack {
            if viewModel.showTabBar {
                TabbarView(
                    viewModel: TabbarViewViewModelImpl(
                        interactor: CoreInteractor(
                            container: container
                        )
                    )
                )
                .transition(.move(edge: .trailing))
            } else {
                OnboardingView(
                    viewModel: OnboardingViewModelImpl(
                        interactor: CoreInteractor(
                            container: container
                        )
                    )
                )
                .transition(.move(edge: .leading))
            }
        }
        .onAppear(perform: viewModel.checkUserStatus)
        .onChange(of: viewModel.showTabBar) { _, newValue in
            if !newValue {
                viewModel.checkUserStatus()
            }
        }
        .animation(.smooth, value: viewModel.showTabBar)
    }
}

#Preview("Mock") {
    
    let container = DevPreview.shared.container
    let manager = DisneyManagerImpl(
        repository: DisneyServiceMock(
            characters: .mock,
            delay: 1.0
        )
    )
    
    let viewModel = AppViewModel(
        interactor: CoreInteractor(
            container: container
        )
    )
    
    container
        .register(DisneyManagerImpl.self, service: manager)
    
    return AppView(viewModel: viewModel)
    .previewEnvironment()
}
