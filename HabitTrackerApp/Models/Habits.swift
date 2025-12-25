//
//  Habits.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 25/12/25.
//

import Foundation

struct Habits: Codable {
    let id: String
    let userId: String
    
    var title: String
    var description: String?
    var iconSymbol: String
    var hexColor: String
    
    var completedDates: [Date]
    
    var targetCount: Int
    var currentCount: Int
    let createdAt: Date
}
