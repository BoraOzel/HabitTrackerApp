//
//  AuthError.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/11/25.
//

import Foundation

enum AuthError: Error {
    case invalidEmail
    case weakPassword
    case wrongPassword
    case userNotFound
    case emailAlreadyInUse
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidEmail: return "İnvalid email format."
        case .weakPassword: return "Weak password. Please use stronger password."
        case .wrongPassword: return "Wrong password."
        case .userNotFound: return "User not found."
        case .emailAlreadyInUse: return "This email is already in use."
        case .unknown: return "An unknown error occured."
        }
    }
}
