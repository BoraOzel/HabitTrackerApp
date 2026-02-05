//
//  HomeViewController.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/11/25.
//

import UIKit

protocol HomeViewControllerInterface: AnyObject,
                                      SpinnerDisplayable {
    func setupCollectionView()
    func performInitialScroll()
    func navigateToHabitScreen(vc: UIViewController)
    func showLoading(show: Bool)
    func createSwipableListLayout()
}


class HomeViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var habitCollectionView: UICollectionView!
    
    var viewModel: HomeViewModelInterface = HomeViewModel(habitService: HabitService())
    
    private var hasInitialScrollPerformed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.view = self
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        performInitialScroll()
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        navigateToHabitScreen(vc: AddHabitViewController())
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
        
        habitCollectionView.register(UINib(nibName: "HabitCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "HabitCollectionViewCell")
    }
    
    func performInitialScroll() {
        if !hasInitialScrollPerformed, let index = viewModel.getScrollIndexForSelectedItem() {
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: index, section: 0)
                self.calendarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                self.hasInitialScrollPerformed = true
            }
        }
    }
    
    func navigateToHabitScreen(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showLoading(show: Bool) {
        show ? showProgress() : removeProgress()
    }
    
    func createSwipableListLayout() {
        habitCollectionView.collectionViewLayout = CollectionViewLayoutFactory.createSwipeableListLayout { [weak self] indexPath in
            guard let self = self else { return }
            
            self.viewModel.deleteHabit(at: indexPath.row)
            self.habitCollectionView.deleteItems(at: [indexPath])
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == calendarCollectionView {
            return viewModel.numberOfDates
        }
        else if collectionView == habitCollectionView {
            return viewModel.numberOfHabits
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == calendarCollectionView {
            guard let calendarCell: CalendarCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell",
                                                                                                    for: indexPath) as? CalendarCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            let date = viewModel.date(index: indexPath.row)
            let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
            
            calendarCell.configure(date: date, isSelected: isSelected)
            calendarCell.configureCell(cell: calendarCell)
            
            return calendarCell
            
        }
        else if collectionView == habitCollectionView {
            guard let habitCell: HabitCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCollectionViewCell",
                                                                                              for: indexPath) as? HabitCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            let habit = viewModel.habit(index: indexPath.row)
            
            let isFuture = viewModel.isSelectedDateInFuture
            
            habitCell.configure(habit: habit, selectedDate: viewModel.selectedDate, isFuture: isFuture)
            
            habitCell.onCompleteTapped = { [weak self] in
                if isFuture { return }
                self?.viewModel.completeHabit(index: indexPath.row)
            }
            
            return habitCell
            
        }
        
        return UICollectionViewCell()
        
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarCollectionView {
            viewModel.selectDate(index: indexPath.row)
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == calendarCollectionView {
            let width = collectionView.frame.width / 5.8
            let height = collectionView.frame.height * 0.58
            
            return CGSize(width: width, height: height)
        }
        else if collectionView == habitCollectionView {
            let width = collectionView.frame.width
            let height = collectionView.frame.height / 4
            
            return CGSize(width: width, height: height)
        }
        return CGSize(width: 80, height: 80)
    }
    
}

extension HomeViewController: HomeViewModelDelegate {
    func reloadData() {
        
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadData()
            self.habitCollectionView.reloadData()
        }
        
    }
    
    func reloadItems(at indices: [Int]) {
        
        let indexPathsToReload = indices.map { IndexPath(item: $0, section: 0) }
        
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadItems(at: indexPathsToReload)
            self.habitCollectionView.reloadItems(at: indexPathsToReload)
        }
        
    }
    
    func scrollToDate(index: Int) {
        
        let indexPath = IndexPath(item: index, section: 0)
        calendarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
    }
    
    func updateHeader(title: String) {
        
        DispatchQueue.main.async {
            self.headerLabel.text = title
        }
        
    }
    
}
