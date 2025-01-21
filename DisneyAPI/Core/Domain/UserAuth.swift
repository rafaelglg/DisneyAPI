//
//  U.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 19/1/25.
//

import Foundation

struct UserAuthModel: Codable, Identifiable, Sendable {
    
    let id: String
    let fullName: String
    let email: String
    let password: String
    let dateCreated: Date?
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let personNameComponent = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            formatter.string(from: personNameComponent)
        }
        return ""
    }
}
