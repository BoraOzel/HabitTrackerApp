//
//  Habits.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 25/12/25.
//

import Foundation
import FirebaseFirestore

struct Habits: Codable {
    @DocumentID var id: String?
    
    let userId: String
    
    var title: String
    var streak: Int?
    
    var completedDates: [Date]
    var selectedDays: [Int]
    var reminderTime: Date
    
    var goalCount: Int
    var currentCount: Int
    var goalUnit: String
    let createdAt: Date
}

extension Habits {
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        let today = Date()
        
        return completedDates.contains { date in
            calendar.isDate(date, inSameDayAs: today)
        }
    }
}
