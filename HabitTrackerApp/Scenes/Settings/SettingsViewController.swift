//
//  ProfileViewController.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/11/25.
//

import UIKit

protocol SettingsViewControllerInterface {
    func setupThemeSegment()
}

class SettingsViewController: UIViewController {
    
    private let authManager = AuthManager.shared
    
    @IBOutlet weak var themeSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        do {
            try authManager.signOut()
            
            guard let window = self.view.window else { return }
            Router.switchToAuth(window: window
            )
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        guard let selectedTheme = ThemeManager.Theme(rawValue: sender.selectedSegmentIndex) else { return }
        ThemeManager.applyTheme(theme: selectedTheme)
    }
    
}

extension SettingsViewController: SettingsViewControllerInterface {
    
    func setupThemeSegment() {
        let currentTheme = ThemeManager.getSavedTheme()
        themeSegmentControl.selectedSegmentIndex = currentTheme.rawValue
    }
    
}
