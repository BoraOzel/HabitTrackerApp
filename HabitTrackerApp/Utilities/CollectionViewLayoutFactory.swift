//
//  CollectionViewLayoutFactory.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 5/2/26.
//

import UIKit

final class CollectionViewLayoutFactory {
    
    private init() { }
    
    static func createSwipeableListLayout(onDelete: @escaping (IndexPath) -> Void) -> UICollectionViewLayout {
            
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.backgroundColor = .clear
            config.showsSeparators = false
            
            config.trailingSwipeActionsConfigurationProvider = { indexPath in
                
                let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, completion in
                    onDelete(indexPath)
                    completion(true)
                }
                
                deleteAction.image = UIImage(systemName: "trash")
                deleteAction.backgroundColor = .systemRed
                
                return UISwipeActionsConfiguration(actions: [deleteAction])
            }
            
            return UICollectionViewCompositionalLayout.list(using: config)
        }
    
}
