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
        
        let statsVC = StatsViewController(nibName: "StatsViewController", bundle: nil)
        let statsNav = UINavigationController(rootViewController: statsVC)
        
        statsNav.tabBarItem = UITabBarItem(title: "Stats",
                                          image: UIImage(systemName: "chart.bar"),
                                          selectedImage: UIImage(systemName: "chart.bar.fill"))
        
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        profileNav.tabBarItem = UITabBarItem(title: "Profile",
                                          image: UIImage(systemName: "person"),
                                          selectedImage: UIImage(systemName: "person.fill"))
        
        self.viewControllers = [homeNav, statsNav, profileNav]
        
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
