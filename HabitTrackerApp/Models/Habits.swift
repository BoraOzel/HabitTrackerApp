//
//  Habits.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 25/12/25.
//

import Foundation

struct Habits: Codable {
    let userId: String
    
    var title: String
    
    var completedDates: [Date]
    var selectedDays: [Int]
    
    var goalCount: Int
    var currentCount: Int
    var goalUnit: String
    let createdAt: Date
}
