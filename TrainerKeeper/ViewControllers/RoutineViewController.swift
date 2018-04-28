//
//  RoutineViewController.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 4/27/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let RoutineViewId = "RoutineViewId"

class RoutineViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet var nameLabel: BoldLabel!
  @IBOutlet var progressView: CProgressView!
  @IBOutlet var progressLabel: RegularLabel!
  @IBOutlet var listView: UICollectionView!
  
  var routine: Routine!
  var layout: UICollectionViewFlowLayout!
  
  // MARK: - Init
  
  class func createControllerFor(routine: Routine) -> RoutineViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: RoutineViewController = storyboard.instantiateViewController(withIdentifier: RoutineViewId) as! RoutineViewController
    viewController.routine = routine
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layout = listView.collectionViewLayout as! UICollectionViewFlowLayout
    nameLabel.text = routine.name
    setupNavBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    listView.reloadData()
  }
  
  private func setupNavBar() {
    if let closeImage = UIImage(named: "Close")?.maskedImageWithColor(UIColor.accent) {
      let closeButton = UIButton(type: .custom)
      closeButton.addTarget(self, action: #selector(closeTapped(_:)), for: .touchUpInside)
      closeButton.setImage(closeImage, for: .normal)
      closeButton.setImage(closeImage, for: .highlighted)
      closeButton.frame = CGRect(x: 0, y: 0, width: closeImage.size.width, height: closeImage.size.height)
      let closeItem = UIBarButtonItem(customView: closeButton)
      navigationItem.leftBarButtonItem = closeItem
    }
    
    navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()
    navigationItem.title = "Routine"
    let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped(_:)))
    navigationItem.rightBarButtonItem = editItem
  }
  
  // MARK: - Layout
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // Update flow layout
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    var size = listView.bounds.size.width
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 4
    if UIDevice.current.orientation.isLandscape {
      size = listView.bounds.height
      layout.minimumInteritemSpacing = 4
      layout.minimumLineSpacing = 0
    }
    var squareDivision: CGFloat = 2.0
    if UIDevice.current.userInterfaceIdiom == .pad {
      squareDivision = 4.0
    }
    let squareSize = CGFloat((size / squareDivision) - 2)
    layout.itemSize = CGSize(width: squareSize, height: squareSize)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 4
    layout.invalidateLayout()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    layout.invalidateLayout()
  }
  
  // MARK: - Actions
  
  @IBAction func closeTapped(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Stop Routine?", message: "Closing will reset your current progress.", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let editAction = UIAlertAction(title: "Stop", style: .default) { (action) in
      self.navigationController?.popViewController(animated: true)
    }
    alert.addAction(cancelAction)
    alert.addAction(editAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func editTapped(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Reset Routine?", message: "Editing will reset your current progress.", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
      let controller = EditRoutineViewController.createControllerFor(routine: self.routine)
      let navController = UINavigationController(rootViewController: controller)
      self.present(navController, animated: true, completion: nil)
    }
    alert.addAction(cancelAction)
    alert.addAction(editAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  // MARK: - Private Methods
  
  private func displayCompletion() {
    routine.completionCount += 1
    RoutineList.shared.saveToCache()
    let alert = UIAlertController(title: "Congrats!", message: "You did it! Your training routine is complete!", preferredStyle: .alert)
    let completeAction = UIAlertAction(title: "Hooray!", style: .default, handler: nil)
    alert.addAction(completeAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  private func calculateCompletion() {
    let percentage = Double(routine.routineSetsCompleted.count) / Double(routine.routineSets.count)
    if percentage == 1.0 {
      displayCompletion()
    }
    progressView.updateProgressCircle(status: Float(percentage * 100))
    let progress = String(Int(percentage * 100))
    progressLabel.text = "\(progress)%"
  }
  
}

extension RoutineViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return routine.routineSets.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetCellId, for: indexPath) as! SetCell
    let routineSet = routine.routineSets[indexPath.row]
    cell.nameLabel.text = "\(routineSet.name) x\(routineSet.repetitions)"
    if routineSet.completed == true {
      cell.completedView.isHidden = false
    } else {
      cell.completedView.isHidden = true
    }
    return cell
  }
}

extension RoutineViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let routineSet = routine.routineSets[indexPath.row]
    routineSet.completed = !routineSet.completed    
    calculateCompletion()
    let percentage = Double(routine.routineSetsCompleted.count) / Double(routine.routineSets.count)
    if percentage == 1.0 {
      displayCompletion()
    }
    progressView.updateProgressCircle(status: Float(percentage * 100))
    let progress = String(Int(percentage * 100))
    progressLabel.text = "\(progress)%"
    collectionView.reloadItems(at: [indexPath])
  }
  
}
