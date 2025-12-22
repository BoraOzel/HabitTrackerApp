//
//  RegisterViewModel.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 18/12/25.
//

import Foundation

protocol RegisterViewModelInterface: AnyObject {
    func signUp(email: String?, password: String?, name: String?, surname: String?, birthdate: Date?) async throws
}

class RegisterViewModel {
    
    private let authManager = AuthManager.shared
    weak var view: RegisterViewControllerInterface?
    
}

extension RegisterViewModel: RegisterViewModelInterface {
    
    @MainActor
    func signUp(email: String?, password: String?, name: String?, surname: String?, birthdate: Date?) async throws {
        
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty,
              let name = name, !name.isEmpty,
              let surname = surname, !surname.isEmpty,
              let birthdate = birthdate
        else {
            throw AuthError.blank
        }
        
        if !email.contains("@") {
            throw AuthError.invalidEmail
        }
        
        try await authManager.registerUser(with: email,
                                           password: password,
                                           name: name,
                                           surname: surname,
                                           birthdate: birthdate)
    }
}
