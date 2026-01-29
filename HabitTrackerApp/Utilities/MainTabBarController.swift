//
//  MainTabBarController.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/11/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setTabBarAppearance()
    }
    
    private func setupTabs() {
     
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let homeNav = UINavigationController(rootViewController: homeVC)
        
        homeNav.tabBarItem = UITabBarItem(title: "Home",
                                          image: UIImage(systemName: "house"),
                                          selectedImage: UIImage(systemName: "house.fill"))
        
        let settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        
        settingsNav.tabBarItem = UITabBarItem(title: "Settings",
                                          image: UIImage(systemName: "gear"),
                                          selectedImage: UIImage(systemName: "gear.fill"))
        
        self.viewControllers = [homeNav, settingsNav]
        
    }
    
    private func setTabBarAppearance() {
        
        let appearance = UITabBarAppearance()

        appearance.stackedLayoutAppearance.selected.iconColor = .systemIndigo
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemIndigo]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.tintColor = .systemIndigo
        
    }
    
}
