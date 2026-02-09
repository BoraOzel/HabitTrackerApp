//
//  SettingsViewModel.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 9/2/26.
//

import Foundation

protocol SettingsViewModelInterface {
    var view: SettingsViewControllerInterface? { get set }
    
    func logout()
    func viewDidLoad()
}

class SettingsViewModel {
    
    private let authManager: AuthManager
    
    weak var view: SettingsViewControllerInterface?
    
    init(authManager: AuthManager = AuthManager.shared) {
        self.authManager = authManager
    }
    
}

extension SettingsViewModel: SettingsViewModelInterface {
    
    func logout() {
        do {
            try authManager.signOut()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func viewDidLoad() {
        view?.setupThemeSegment()
    }
    
}
