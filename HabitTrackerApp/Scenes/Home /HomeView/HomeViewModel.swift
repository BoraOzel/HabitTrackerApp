//
//  HomeViewModel.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 24/12/25.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func reloadData()
    func reloadItems(at indices: [Int])
    func scrollToDate(index: Int)
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
    
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    
    private(set) var dates: [Date] = []
    private(set) var selectedDate = Date()
    //private var habits: [Habit]
    
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
    
}
