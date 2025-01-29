//
//  NSError+EXT.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 27/1/25.
//
import Foundation
import FirebaseAuth

extension NSError {
    
    func getErrorMessage() -> (errorMessage: String, errorType: AuthErrorCode?) {
        
        let code = AuthErrorCode(rawValue: self.code)
        switch code {
        case .invalidCredential:
            return ("Wrong email or password, please check again", .invalidCredential)
        case .emailAlreadyInUse:
            return ("The email address is already in use by another account. please use a different email", .emailAlreadyInUse)
        case .invalidEmail:
            return ("Invalid email, please ensure to add a correct email", .invalidEmail)
        case .wrongPassword:
            return ("Wrong password, please check again", .wrongPassword)
        case .networkError:
            return ("No internet connection. Please check your internet connection and try again later.", .networkError)
        case .weakPassword:
            return ("Weak password, please ensure to have a minimun of 6 characters", .weakPassword)
        case .sessionExpired:
            return ("Session expired, try again authentication methods", .sessionExpired)
        case .tooManyRequests:
            return ("We have blocked all requests from this device due to many attempts. Try again later.", .tooManyRequests)
        case .requiresRecentLogin:
            return ("This operation is sensitive and in order to do it you need to sign in again first.", .requiresRecentLogin)
        default:
            // If the error is not catch by the switch return default custom error description from firebase
            return (self.localizedDescription, .init(rawValue: code?.rawValue ?? 0))
        }
    }
}
