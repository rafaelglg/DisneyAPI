//
//  File.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 12/1/25.
//

extension Array {
    
    func getFirstAndShuffled<T>(_ transform: (Element) -> T?) -> T? {
        self.compactMap(transform).shuffled().first
    }
}
