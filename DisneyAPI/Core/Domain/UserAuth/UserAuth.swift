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
    let password: String?
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
    
    static var mock: UserAuthModel {
        mocks[0]
    }
    
    static var mocks: [UserAuthModel] {
        return [
            UserAuthModel(
                id: "1",
                fullName: "Jose Menendez",
                email: "jose@mail.com",
                password: "1234",
                dateCreated: .distantPast,
                profilePicture: "",
                isAnonymous: false,
                lastSignInDate: .now
            ),
            UserAuthModel(
                id: "2",
                fullName: "Carlos Menendez",
                email: "carlos@mail.com",
                password: "5678",
                dateCreated: .distantPast,
                profilePicture: "",
                isAnonymous: true,
                lastSignInDate: .now
            ),
            UserAuthModel(
                id: "3",
                fullName: "Steven Menendez",
                email: "steven@mail.com",
                password: "91011",
                dateCreated: .now,
                profilePicture: "",
                isAnonymous: true,
                lastSignInDate: .now
            ),
            UserAuthModel(
                id: "4",
                fullName: "Mark Menendez",
                email: "mark@mail.com",
                password: "121314",
                dateCreated: .distantPast,
                profilePicture: "",
                isAnonymous: false,
                lastSignInDate: .now
            )
        ]
    }
}
