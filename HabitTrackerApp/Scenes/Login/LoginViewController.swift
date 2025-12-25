//
//  LoginViewController.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/11/25.
//

import UIKit

protocol LoginViewControllerInterface: AnyObject {
    func navigateToReigster(vc: UIViewController)
    func navigateToApp()
}

class LoginViewController: UIViewController,
                           AlertPresentable {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var viewModel: LoginViewModelInterface
    
    init(viewModel: LoginViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        Task {
            do {
                try await viewModel.login(email: emailTextField.text, password: passwordTextField.text)
                navigateToApp()
            }
            catch {
                if let authError = error as? AuthError {
                    showAlert(title: "Error",
                              message: authError.localizedDescription,
                              buttonText: "OK")
                }
            }
        }
        
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        navigateToReigster(vc: RegisterViewController(viewModel: RegisterViewModel()))
    }
    
}

extension LoginViewController: LoginViewControllerInterface {
    
    func navigateToReigster(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToApp() {
        
        guard let window = self.view.window else { return }
        Router.switchToApp(window: window)
        
    }
    
}
