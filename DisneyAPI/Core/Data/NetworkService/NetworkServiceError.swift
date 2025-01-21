//
//  NetworkServiceError.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import Foundation

enum NetworkServiceError: Error, LocalizedError {
    case badURL

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The url doesn't exist, try another one"
        }
    }
}
