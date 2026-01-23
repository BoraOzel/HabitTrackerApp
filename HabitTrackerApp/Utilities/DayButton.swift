//
//  DayButton.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 20/1/26.
//

import Foundation
import UIKit


class DayButton: UIButton {
    
    var dayIndex: Int = 0
    
    override var isSelected: Bool {
        
        didSet {
            updateAppearance()
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func updateAppearance() {
        
        if isSelected {
            backgroundColor = isSelected ? .systemIndigo : .tintColor
            setTitleColor(isSelected ? .white : .label, for: .normal)
            layer.borderColor = isSelected ? UIColor.systemIndigo.cgColor : UIColor.systemGray4.cgColor
        }
        else {
            self.backgroundColor = .clear
            self.setTitleColor(.label, for: .normal)
            self.layer.borderColor = UIColor.systemGray4.cgColor
        }
        
    }
    
    private func setup() {
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        updateAppearance()
        
    }
    
    @objc func buttonClicked() {
        isSelected.toggle()
    }
    
}
