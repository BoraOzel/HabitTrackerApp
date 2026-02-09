//
//  ProfileViewController.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/11/25.
//

import UIKit

protocol SettingsViewControllerInterface: AnyObject {
    func setupThemeSegment()
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var themeSegmentControl: UISegmentedControl!
    
    private var viewModel: SettingsViewModelInterface
    
    init(viewModel: SettingsViewModelInterface = SettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: "SettingsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        viewModel.logout()
        guard let window = self.view.window else { return }
        Router.switchToAuth(window: window)
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
