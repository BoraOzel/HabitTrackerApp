//
//  RegisterViewController.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 28/11/25.
//

import UIKit

protocol RegisterViewControllerInterface: AnyObject {
    func navigateToApp()
}

class RegisterViewController: UIViewController,
                              AlertPresentable{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
    private var viewModel: RegisterViewModelInterface
    
    init(viewModel: RegisterViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: "RegisterViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        Task {
            do {
                try await viewModel.signUp(email: emailTextField.text,
                                           password: passwordTextField.text,
                                           name: nameTextField.text,
                                           surname: surnameTextField.text)
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
}

extension RegisterViewController: RegisterViewControllerInterface {
    func navigateToApp() {
        guard let window = self.view.window else { return }
        Router.switchToApp(window: window)
    }
}
