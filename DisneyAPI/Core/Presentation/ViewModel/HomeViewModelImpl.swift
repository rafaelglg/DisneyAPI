//
//  HomeViewModelImpl.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 14/1/25.
//
import Foundation

@MainActor
protocol HomeViewModelInteractor {
    func getAllCharacters() async throws
    var allCharacters: [CharacterDataResponse] { get }
}

extension CoreInteractor: HomeViewModelInteractor { }

@Observable
@MainActor
final class HomeViewModelImpl {
    let interactor: HomeViewModelInteractor
    
    private(set) var isLoading: Bool = false
    private(set) var allCharacters: [CharacterDataResponse] = []
    
    init(interactor: HomeViewModelInteractor) {
        self.interactor = interactor
    }
    
//    func getAllCharacters() async {
//        isLoading = true
//        allCharacters = interactor.allCharacters
//        defer {
//            isLoading = false
//        }
//        
//        do {
//            try await interactor.getAllCharacters()
//        } catch {
//            print(error)
//            print(error.localizedDescription)
//        }
//    }
}
