//
//  NSError+EXT.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 27/1/25.
//
import Foundation
import FirebaseAuth

extension NSError {
    
    func getErrorMessage() -> String {
        
        let code = AuthErrorCode(rawValue: self.code)
        switch code {
        case .invalidCredential:
            return "Wrong email or password, please check again"
        case .emailAlreadyInUse:
            return "The email address is already in use by another account. please use a different email"
        case .invalidEmail:
            return "Invalid email, please ensure to add a correct email"
        case .wrongPassword:
            return "Wrong password, please check again"
        case .networkError:
            return "No internet connection. Please check your internet connection and try again later."
        case .weakPassword:
            return "Weak password, please ensure to have a minimun of 6 characters"
        case .sessionExpired:
            return "Session expired, try again authentication methods"
        case .tooManyRequests:
            return "We have blocked all requests from this device due to many attempts. Try again later."
        default:
            // If the error is not catch by the switch return default custom error description from firebase
            return self.localizedDescription
        }
    }
}
