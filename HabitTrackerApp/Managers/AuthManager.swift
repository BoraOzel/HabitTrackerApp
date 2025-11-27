//
//  AuthManager.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/11/25.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    var userSessionId: String? {
        return currentUser?.uid
    }
    
    
    func registerUser(with email: String, password: String) async throws -> AuthDataResult {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return result
        }
        catch {
            throw mapFirebaseError(error)
        }
    }
    
    func signIn(with email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw mapFirebaseError(error)
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw error
        }
    }
    
    private func mapFirebaseError(_ error: Error) -> AuthError {
        guard let nsError = error as NSError? else { return .unknown }
        
        if let errorCode = AuthErrorCode(rawValue: nsError.code) {
            switch errorCode {
            case .invalidEmail:
                return .invalidEmail
            case .weakPassword:
                return .weakPassword
            case .wrongPassword:
                return .wrongPassword
            case .userNotFound:
                return .userNotFound
            case .emailAlreadyInUse:
                return .emailAlreadyInUse
            default:
                return .unknown
            }
        }
        return .unknown
    }
    
}

