//
//  LoginViewController.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/11/25.
//

import UIKit

class LoginViewController: UIViewController,
                           AlertPresentable {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error",
                      message: "Email/password can not be empty.",
                      buttonText: "OK")
            return
        }
        
        Task {
            do {
                try await AuthManager.shared.signIn(with: email, password: password)
                
            }
            catch let error as AuthError {
                showAlert(title: "Error",
                          message: error.localizedDescription,
                          buttonText: "OK")
            }
        }
    }
    @IBAction func registerButtonClicked(_ sender: Any) {
        
    }
}
