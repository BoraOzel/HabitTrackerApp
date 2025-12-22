//
//  ProfileViewController.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/11/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let authManager = AuthManager.shared
    
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
}
