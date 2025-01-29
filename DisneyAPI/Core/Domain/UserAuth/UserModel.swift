//
//  UserModel.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 28/1/25.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let fullName: String
    let email: String
    let dateCreated: Date?
    let profilePicture: String?
    let isAnonymous: Bool
    let lastSignInDate: Date?
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let personNameComponent = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: personNameComponent)
        }
        return ""
    }
}
