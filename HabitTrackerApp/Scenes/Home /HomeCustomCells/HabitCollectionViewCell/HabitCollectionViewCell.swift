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
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
