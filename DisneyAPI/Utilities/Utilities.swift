//
//  Utilities.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import Foundation

struct Utilities {
    
    static func getURLPath(baseUrl: EndingPath = .basePath,
                           endingPath: EndingPath) -> String {
        "\(baseUrl.path)\(endingPath.path)"
    }
}

enum EndingPath {
    
    case basePath
    case allCharacters
    case oneCharacter(id: String)
    
    var path: String {
        switch self {
        case .allCharacters:
            return "character?pageSize=7438"
        case .oneCharacter(let id):
            return "character/\(id)"
        case .basePath:
            return "https://api.disneyapi.dev/"
        }
    }
}
