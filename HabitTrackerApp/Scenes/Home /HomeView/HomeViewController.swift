//
//  HomeViewController.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/11/25.
//

import UIKit

protocol HomeViewControllerInterface: AnyObject {
    func setupCollectionView()
    func performInitialScroll()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var habitCollectionView: UICollectionView!
    
    var viewModel: HomeViewModelInterface = HomeViewModel()
    
    private var hasInitialScrollPerformed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        performInitialScroll()
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
    }
    
}

extension HomeViewController: HomeViewControllerInterface {
    
    func setupCollectionView() {
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        habitCollectionView.delegate = self
        habitCollectionView.dataSource = self
        
        calendarCollectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil),
                                        forCellWithReuseIdentifier: "CalendarCollectionViewCell")
        
    }
    
    func performInitialScroll() {
        
        if !hasInitialScrollPerformed {
            if let index = viewModel.getScrollIndexForSelectedItem() {
                
                let indexPath = IndexPath(item: index, section: 0)
                calendarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                hasInitialScrollPerformed = true
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == calendarCollectionView {
            return viewModel.numberOfDates
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == calendarCollectionView {
            
            guard let cell: CalendarCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell",
                                                                                            for: indexPath) as? CalendarCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let date = viewModel.date(index: indexPath.row)
            let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
            
            cell.configure(date: date, isSelected: isSelected)
            cell.configureCell(cell: cell)
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectDate(index: indexPath.row)
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == calendarCollectionView {
            let width = collectionView.frame.width / 6
            return CGSize(width: width, height: collectionView.frame.height * 0.6)
        }
        return CGSize(width: 80, height: 80)
    }
    
}

extension HomeViewController: HomeViewModelDelegate {
    func reloadData() {
        
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadData()
        }
        
    }
    
    func reloadItems(at indices: [Int]) {
        
        let indexPathsToReload = indices.map { IndexPath(item: $0, section: 0) }
        
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadItems(at: indexPathsToReload)
        }
        
    }
    
    func scrollToDate(index: Int) {
        
        let indexPath = IndexPath(item: index, section: 0)
        calendarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
    }
}
