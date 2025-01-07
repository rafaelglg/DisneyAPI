//
//  SearchView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import SwiftUI

struct SearchView: View {
    
    @State var viewModel: HomeViewModel
    @State private var text: String = ""
    @State private var promt: LocalizedStringKey = "Search your favorite character"
    
    var body: some View {
        List {
            Text("hola")
                .removeListRowFormatting()
        }
        .searchable(text: $text, prompt: promt)
    }
}

#Preview {
    NavigationStack {
        SearchView(viewModel: HomeViewModel(interactor: CoreInteractor(characterRepository: CharacterServiceMock(characters: .mock))))
    }
}
