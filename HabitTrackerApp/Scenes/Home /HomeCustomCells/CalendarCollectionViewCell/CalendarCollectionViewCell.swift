//
//  CalendarCollectionViewCell.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 24/12/25.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(cell: UICollectionViewCell) {
        
        containerView.layer.cornerRadius = 30
        containerView.layer.masksToBounds = true
        
    }
    
    func configure(date: Date, isSelected: Bool) {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        
        formatter.dateFormat = "EEE"
        dayNameLabel.text = formatter.string(from: date).uppercased()
        
        formatter.dateFormat = "d"
        dayNumberLabel.text = formatter.string(from: date)
        
        if isSelected {
            containerView.backgroundColor = .systemIndigo
        }
        else {
            containerView.backgroundColor = .systemGray
        }
    }
    
}
