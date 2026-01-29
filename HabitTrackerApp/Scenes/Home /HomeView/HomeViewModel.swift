//
//  HomeViewModel.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 24/12/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol HomeViewModelDelegate: AnyObject {
    func reloadData()
    func reloadItems(at indices: [Int])
    func scrollToDate(index: Int)
    func updateHeader(title: String)
}

protocol HomeViewModelInterface {
    var delegate: HomeViewModelDelegate? { get set }
    var dates: [Date] { get }
    var selectedDate: Date { get }
    var numberOfDates: Int {get}
    var numberOfHabits: Int { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func date(index: Int) -> Date
    func selectDate(index: Int)
    func habit(index: Int) -> Habits
    func getScrollIndexForSelectedItem() -> Int?
    func fetchUserData()
    func fetchHabits()
    func filterHabitsForSelectedDate()
    func completeHabit(index: Int)
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    
    private(set) var dates: [Date] = []
    private(set) var selectedDate = Date()
    private var habits: [Habits] = []
    private var displayedHabits: [Habits] = []
    private var db = Firestore.firestore()
    
    private func setupCalendarData() {
        dates.removeAll()
        let calendar = Calendar.current
        let today = Date()
        
        for i in -15...15 {
            if let date = calendar.date(byAdding: .day, value: i, to: today){
                dates.append(date)
            }
        }
    }
    
}

extension HomeViewModel: HomeViewModelInterface {
    
    var numberOfDates: Int {
        return dates.count
    }
    
    var numberOfHabits: Int {
        return displayedHabits.count
    }
    
    func viewDidLoad() {
        setupCalendarData()
        fetchUserData()
        fetchHabits()
        delegate?.reloadData()
    }
    
    func viewWillAppear() {
        fetchHabits()
    }
    
    func date(index: Int) -> Date {
        return dates[index]
    }
    
    func habit(index: Int) -> Habits {
        return displayedHabits[index]
    }
    
    func selectDate(index: Int) {
        
        let calendar = Calendar.current
        let oldIndex = dates.firstIndex(where: { calendar.isDate($0, inSameDayAs: selectedDate) })
        
        self.selectedDate = dates[index]
        filterHabitsForSelectedDate()
        
        var indicesToReload: [Int] = [index]
        
        if let old = oldIndex, old != index {
            indicesToReload.append(old)
        }
        
        delegate?.reloadItems(at: indicesToReload)
        delegate?.scrollToDate(index: index)
        
    }
    
    func getScrollIndexForSelectedItem() -> Int? {
        
        let calendar = Calendar.current
        return dates.firstIndex(where: { calendar.isDate($0, inSameDayAs: selectedDate) })
        
    }
    
    func fetchUserData() {
        
        let id = AuthManager.shared.currentUser?.uid
        
        db.collection("users").document(id!).getDocument { snapshot, error  in  // remove force unwrap
            
            guard let document = snapshot, document.exists, let data = document.data() else {
                print("document could not found.")
                return
            }
            
            if let name = data["name"] as? String {
                let titleText = "Hi, \(name)"
                self.delegate?.updateHeader(title: titleText)
            }
        }
    }
    
    func fetchHabits() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("habits")
            .whereField("userId", isEqualTo: uid)
            .order(by: "createdAt", descending: true).getDocuments { [weak self] snapshot, error  in
                
                guard let self = self else { return }
                
                guard let documents = snapshot?.documents else { return }
                
                self.habits = documents.compactMap{ document -> Habits? in
                    return try? document.data(as: Habits.self)
                }
                self.filterHabitsForSelectedDate()
            }
    }
    
    func filterHabitsForSelectedDate() {
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: selectedDate)
        
        displayedHabits = habits.filter { habit in
            return habit.selectedDays.contains(weekday)
        }
        delegate?.reloadData()
        
    }
    
    func completeHabit(index: Int) {
        
        var habit = displayedHabits[index]
        
        let today = Date()
        let calendar = Calendar.current
        
        let isCompletedToday = habit.completedDates.contains { date in
            calendar.isDate(date, inSameDayAs: today)
        }
        
        if isCompletedToday {
            habit.completedDates.removeAll { date in
                calendar.isDate(date, inSameDayAs: today)
            }
            habit.currentCount = max(0, habit.currentCount - 1)
        }
        else {
            habit.completedDates.append(today)
            habit.currentCount += 1
        }
        displayedHabits[index] = habit
        
        if let indexInAll = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[indexInAll] = habit
        }
        delegate?.reloadItems(at: [index])
        
        guard let documentId = habit.id else {
            print("Document ID can not found.")
            return
        }
        
        db.collection("habits").document(documentId).updateData([
            "currentCount": habit.currentCount,
            "completedDates": habit.completedDates
        ])
    }
    
}
