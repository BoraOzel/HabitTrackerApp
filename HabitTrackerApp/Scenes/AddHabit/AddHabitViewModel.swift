//
//  AddHabitViewModel.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/12/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AddHabitViewModelInterface {
    func saveHabit(title: String,selectedDays: [Int], goalCount: Int, goalUnit: String)
}

class AddHabitViewModel {
    
    private let db = Firestore.firestore()
    
}

extension AddHabitViewModel: AddHabitViewModelInterface {
    
    func saveHabit(title: String,selectedDays: [Int], goalCount: Int, goalUnit: String) {
        
        let habitId = UUID().uuidString
        
        let newHabit = Habits(userId: AuthManager.shared.currentUser!.uid,
                              title: title,
                              completedDates: [],
                              selectedDays: selectedDays,
                              goalCount: goalCount,
                              currentCount: 0,
                              goalUnit: goalUnit,
                              createdAt: Date())
        
        do {
            try db.collection("habits").document(habitId).setData(from: newHabit) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    print("saved succesfully")
                }
            }
        }
        catch {
            print("errorr")
        }
    }
}
