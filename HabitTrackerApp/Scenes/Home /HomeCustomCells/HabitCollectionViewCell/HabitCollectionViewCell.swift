//
//  HabitCollectionViewCell.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 24/12/25.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var habitNameLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    
    var onCompleteTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(habit: Habits) {
        
        habitNameLabel.text = habit.title
        goalLabel.text = "\(habit.goalCount) \(habit.goalUnit)"
        streakLabel.text = "⚡️ \(habit.streak ?? 0)"
        setupGesture()
        
        if habit.isCompletedToday {
            checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
            checkmarkImageView.tintColor = .systemGreen
            containerView.alpha = 0.8
        } else {
            checkmarkImageView.image = UIImage(systemName: "circle")
            checkmarkImageView.tintColor = .systemGray3
            containerView.alpha = 1.0
        }
        
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = .systemGray5
        
    }
    
    func setupGesture() {
        
        checkmarkImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        checkmarkImageView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.checkmarkImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.checkmarkImageView.transform = .identity
            }
        }
        onCompleteTapped?()
    }
    
}
