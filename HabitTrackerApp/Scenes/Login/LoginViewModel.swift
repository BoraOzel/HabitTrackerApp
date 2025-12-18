//
//  LoginViewModel.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 18/12/25.
//

import Foundation

protocol LoginViewModelInterface {
    func login(email: String?, password: String?) async throws
}

class LoginViewModel {
    
    private let authManager = AuthManager.shared
    weak var view: LoginViewControllerInterface?
    
}

extension LoginViewModel: LoginViewModelInterface {
    
    @MainActor
    func login(email: String?, password: String?) async throws {
        
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            throw AuthError.blank
        }
        
        if !email.contains("@") {
            throw AuthError.invalidEmail
        }
        
        do{
            try await authManager.signIn(with: email, password: password)
        }
        catch
        {
            let nsError = error as NSError
            
            if nsError.code == 17009 {
                throw AuthError.wrongPassword
            }
            else {
                throw AuthError.unknown
            }
        }
    }
}
