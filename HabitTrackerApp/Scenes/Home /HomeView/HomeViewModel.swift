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
    //var numberOfHabits: Int { get }
    
    func viewDidLoad()
    func date(index: Int) -> Date
    func selectDate(index: Int)
    //func habit(index: Int) ->
    func getScrollIndexForSelectedItem() -> Int?
    func fetchUserData()
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    
    private(set) var dates: [Date] = []
    private(set) var selectedDate = Date()
    //private var habits: [Habit]
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
    
    func viewDidLoad() {
        setupCalendarData()
        fetchUserData()
        delegate?.reloadData()
    }
    
    func date(index: Int) -> Date {
        return dates[index]
    }
    
    func selectDate(index: Int) {
        
        let calendar = Calendar.current
        let oldIndex = dates.firstIndex(where: { calendar.isDate($0, inSameDayAs: selectedDate) })
        
        self.selectedDate = dates[index]
        
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
    
}
