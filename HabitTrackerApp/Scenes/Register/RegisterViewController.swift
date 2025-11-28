//
//  RegisterViewController.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 28/11/25.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signUpButtonClicked(_ sender: Any) {
        
    }
}
