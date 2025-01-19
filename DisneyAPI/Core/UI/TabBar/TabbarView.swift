//
//  TabbarView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 6/1/25.
//

import SwiftUI

struct TabbarView: View {
    
    @Environment(DependencyContainer.self) var container
    @State var viewModel: TabbarViewViewModelImpl
    
    var body: some View {
        
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView(
                    viewModel: HomeViewModelImpl(
                        interactor: CoreInteractor(
                            container: container
                        )
                    )
                )
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView(
                    viewModel: SearchViewModelImpl(
                        interactor: CoreInteractor(
                            container: container
                        )
                    )
                )
            }
            
            Tab("Profile", systemImage: "person") {
                ProfileView(
                    viewModel: ProfileViewModel(
                        interactor: CoreInteractor(
                            container: container
                        )
                    )
                )
            }
        }
        .sheet(isPresented: $viewModel.shouldPresentSignIn) {
            SignInProcessView()
                .presentationDetents([.fraction(0.45)])
        }
    }
}

#Preview("Real characters") {
    
    @Previewable @State var manager = CharacterManagerImpl(
        repository: CharacterServiceImpl()
    )
    
    let container = DevPreview.shared.container
    container.register(CharacterManagerImpl.self, service: manager)
    let viewModel = TabbarViewViewModelImpl(
        interactor: CoreInteractor(
            container: container
        )
    )
    
    return TabbarView(viewModel: viewModel)
        .previewEnvironment()
}

#Preview("Mock characters") {
    
    @Previewable @State var manager = CharacterManagerImpl(
        repository: CharacterServiceMock(
            characters: .mock
        )
    )
    
    let container = DevPreview.shared.container
    let viewModel = TabbarViewViewModelImpl(
        interactor: CoreInteractor(
            container: container
        )
    )
    
    return TabbarView(viewModel: viewModel)
        .previewEnvironment()
}

#Preview("With signIn view") {
    
    @Previewable @State var manager = CharacterManagerImpl(
        repository: CharacterServiceMock(
            characters: .mock
        )
    )
    
    let container = DevPreview.shared.container
    let viewModel = TabbarViewViewModelImpl(
        interactor: CoreInteractor(
            container: container
        )
    )
    viewModel.presentSignIn = true
    
    return TabbarView(viewModel: viewModel)
        .previewEnvironment()
}
