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
    case filterCharacter(name: String)
    case oneCharacter(id: String)
    
    var path: String {
        switch self {
        case .allCharacters:
            return "character"
        case .filterCharacter(let name):
            return "character?name=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        case .oneCharacter(let id):
            return "character/\(id)"
        case .basePath:
            return "https://api.disneyapi.dev/"
        }
    }
}
