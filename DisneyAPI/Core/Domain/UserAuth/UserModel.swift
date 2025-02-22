//
//  UserModel.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 28/1/25.
//

import Foundation

struct UserModel: Codable, Identifiable, Equatable {
    let id: String
    let fullName: String
    let email: String
    let dateCreated: Date?
    let profilePicture: String?
    let isAnonymous: Bool
    let lastSignInDate: Date?
    
    init(
        id: String,
        fullName: String,
        email: String,
        dateCreated: Date?,
        profilePicture: String? = nil,
        isAnonymous: Bool,
        lastSignInDate: Date?
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.dateCreated = .now
        self.profilePicture = profilePicture
        self.isAnonymous = isAnonymous
        self.lastSignInDate = lastSignInDate
    }
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let personNameComponent = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: personNameComponent)
        }
        return ""
    }
    
    static var mock: UserModel {
        mocks[0]
    }
    
    static var mocks: [UserModel] {
        return [
            UserModel(id: "1", fullName: "Jose menendez", email: "jose@mail.com", dateCreated: .distantPast, profilePicture: "", isAnonymous: false, lastSignInDate: .now),
            UserModel(id: "2", fullName: "Carlos Menendez", email: "carlos@mail.com", dateCreated: .distantPast, profilePicture: "", isAnonymous: true, lastSignInDate: .now),
            UserModel(id: "3", fullName: "Steven Menendez", email: "", dateCreated: .now, isAnonymous: true, lastSignInDate: .now),
            UserModel(id: "4", fullName: "Mark Menendez", email: "mark@mail.com", dateCreated: .distantPast, isAnonymous: true, lastSignInDate: .now)
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case dateCreated = "date_created"
        case profilePicture = "profile_picture"
        case isAnonymous = "is_anonymous"
        case lastSignInDate = "last_sign_in_date"
    }
}
