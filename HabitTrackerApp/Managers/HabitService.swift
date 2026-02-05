//
//  HabitService.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 4/2/26.
//

import Foundation
import FirebaseFirestore

protocol HabitServiceProtocol {
    func fetchUser(userId: String) async throws -> AppUser
    func fetchHabits(userId: String) async throws -> [Habits]
    func updateHabit(habit: Habits) async throws
    func deleteHabit(habitId: String) async throws
}

class HabitService: HabitServiceProtocol {
    
    private let db = Firestore.firestore()
    
    func fetchUser(userId: String) async throws -> AppUser {
        
        let snapshot = try await db.collection("users").document(userId).getDocument()
        
        return try snapshot.data(as: AppUser.self)
    }
    
    func fetchHabits(userId: String) async throws -> [Habits] {
        
        let snapshot = try await db.collection("habits")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        let habits = snapshot.documents.compactMap { try? $0.data(as: Habits.self)}
        return habits
    }
    
    func updateHabit(habit: Habits) async throws {
        
        guard let id = habit.id else { return }
        
        try await db.collection("habits").document("id").updateData([
            "currentCount": habit.currentCount,
            "completedDates": habit.completedDates,
            "streak": habit.streak ?? 0
        ])
        
    }
    
    func deleteHabit(habitId: String) async throws {
        try await db.collection("habits").document(habitId).delete()
    }
    
}
