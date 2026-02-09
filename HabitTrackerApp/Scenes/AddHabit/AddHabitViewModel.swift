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
    var habitToEdit: Habits? { get }
    var initalHabitName: String { get }
    var initalSelectedDays: [Int] { get }
    var screenTitle: String { get }
    var buttonTitle: String { get }
    
    func saveHabit(title: String,selectedDays: [Int],reminderTime: Date, goalCount: Int, goalUnit: String)
    func viewDidLoad()
}

class AddHabitViewModel {
    
    private let habitService: HabitServiceProtocol
    private let db = Firestore.firestore()
    
    weak var view: AddHabitViewControllerInterface?
    var habitToEdit: Habits?
    
    init(habitToEdit: Habits? = nil,
         habitService: HabitServiceProtocol = HabitService()) {
        self.habitToEdit = habitToEdit
        self.habitService = habitService
    }
    
    var initalHabitName: String {
        return habitToEdit?.title ?? ""
    }
    
    var initalSelectedDays: [Int] {
        return habitToEdit?.selectedDays ?? []
    }
    
    var screenTitle: String {
        return habitToEdit != nil ? "Edit Habit" : "Add Habit"
    }
    
    var buttonTitle: String {
        return habitToEdit != nil ? "Update" : "Save"
    }
    
}

extension AddHabitViewModel: AddHabitViewModelInterface {
    
    func saveHabit(title: String,selectedDays: [Int], reminderTime: Date, goalCount: Int, goalUnit: String) {
        
        if let existingHabit = habitToEdit {
            var updatedHabit = existingHabit
            
            updatedHabit.title = title
            updatedHabit.selectedDays = selectedDays
            updatedHabit.reminderTime = reminderTime
            updatedHabit.goalCount = goalCount
            updatedHabit.goalUnit = goalUnit
            
            Task {
                try await habitService.updateHabit(habit: updatedHabit)
            }
        }
        else {
            guard let userId = AuthManager.shared.currentUser?.uid else { return }
            let newHabit = Habits(userId: userId,
                                  title: title,
                                  completedDates: [],
                                  selectedDays: selectedDays,
                                  reminderTime: reminderTime,
                                  goalCount: goalCount,
                                  currentCount: 0,
                                  goalUnit: goalUnit,
                                  createdAt: Date())
            
            Task {
                try await habitService.addHabit(habit: newHabit)
            }
        }
        
    }
    
    func viewDidLoad() {
        view?.assignButtonIds()
        view?.setInitalValues()
    }
    
}
