//
//  AddHabitViewController.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/12/25.
//

import UIKit

protocol AddHabitViewControllerInterface {
    func getSelectedFrequency() -> [Int]
    func assignButtonIds()
}

class AddHabitViewController: UIViewController,
                              AlertPresentable {

    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var goalAmountTextField: UITextField!
    @IBOutlet weak var goalUnitTextField: UITextField!
    @IBOutlet weak var remindDateTimePicker: UIDatePicker!
    @IBOutlet var dayButtons: [DayButton]!
    
    private var viewModel: AddHabitViewModelInterface = AddHabitViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignButtonIds()
    }

    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let selectedDays = getSelectedFrequency()
        
        if selectedDays.isEmpty {
           showAlert(title: "Error",
                     message: "Please select at least 1 day.",
                     buttonText: "OK")
            return
        }
        
        if let title = habitNameTextField.text,
           let goalCount = goalAmountTextField.text,
           let goalUnit = goalUnitTextField.text
        {
            let reminderTime = remindDateTimePicker.date
            
            viewModel.saveHabit(title: title,selectedDays: selectedDays, reminderTime: reminderTime, goalCount: Int(goalCount)!, goalUnit: goalUnit)
            showAlert(title: "Saved",
                      message: "Your habit saved successfully.",
                      buttonText: "OK") { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            showAlert(title: "Error",
                      message: "Please fill all the blanks.",
                      buttonText: "OK")
        }
        
    }
    
}

extension AddHabitViewController: AddHabitViewControllerInterface {
    
    func getSelectedFrequency() -> [Int] {
        return dayButtons.filter { $0.isSelected }.map { $0.dayIndex }.sorted()
    }
    
    func assignButtonIds() {
        
        dayButtons = dayButtons.sorted{ $0.tag < $1.tag }
        
        let calendarIndices = [2, 3, 4, 5, 6, 7, 1]
        
        for (index, button) in dayButtons.enumerated() {
            button.dayIndex = calendarIndices[index]
        }
        
    }
    
}
