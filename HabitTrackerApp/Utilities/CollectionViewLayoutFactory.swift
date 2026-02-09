//
//  CollectionViewLayoutFactory.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 5/2/26.
//

import UIKit

final class CollectionViewLayoutFactory {
    
    private init() { }
    
    static func createSwipeableListLayout(onDelete: @escaping (IndexPath) -> Void,
                                          onEdit: @escaping (IndexPath) -> Void) -> UICollectionViewLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .clear
        config.showsSeparators = false
        
        config.trailingSwipeActionsConfigurationProvider = { indexPath in
            
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
                onDelete(indexPath)
                completion(true)
            }
            
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
        config.leadingSwipeActionsConfigurationProvider = { indexPath in
            
            let editAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
                onEdit(indexPath)
                completion(true)
            }
            
            editAction.image = UIImage(systemName: "pencil")
            editAction.backgroundColor = .systemBlue
            
            return UISwipeActionsConfiguration(actions: [editAction])
        }
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
}
