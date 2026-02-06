//
//  ThemeManager.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 6/2/26.
//

import UIKit

final class ThemeManager {
    
    private init() { }
    
    static let selectedThemeKey = "SelectedTheme"
    
    enum Theme: Int {
        case device = 0
        case light = 1
        case dark = 2
        
        var userInterfaceStyle: UIUserInterfaceStyle {
            switch self {
            case .device: return .unspecified
            case .light: return .light
            case .dark: return .dark
            }
        }
    }
    
    static func applyTheme(theme: Theme) {
        
        UserDefaults.standard.set(theme.rawValue, forKey: selectedThemeKey)
        
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
        
        windows.forEach { window in
            window.overrideUserInterfaceStyle = theme.userInterfaceStyle
        }
        
    }
    
    static func getSavedTheme() -> Theme {
        let savedTheme = UserDefaults.standard.integer(forKey: selectedThemeKey)
        return Theme(rawValue: savedTheme) ?? .device
    }
    
}
