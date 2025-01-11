//
//  Collection+EXT.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 11/1/25.
//

extension Collection {
    /// Returns the first `n` elements of the collection.
    /// If `n` is greater than the number of elements, it returns all the elements.
    func first(_ number: Int) -> [Element] {
        return Array(prefix(number))
    }
    
    /// Returns the last `n` elements of the collection.
    /// If `n` is greater than the number of elements, it returns all the elements.
    func last(_ number: Int) -> [Element] {
        return Array(suffix(number))
    }
}
