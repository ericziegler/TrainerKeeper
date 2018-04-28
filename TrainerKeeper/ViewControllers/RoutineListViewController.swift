//
//  RoutineListViewController.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 4/26/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import UIKit

class RoutineListViewController: UIViewController {

  // MARK: - Properties
  
  @IBOutlet var routineTable: UITableView!
  
  // MARK: - Init
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavBar()
    setupTable()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    routineTable.reloadData()
  }
  
  private func setupNavBar() {
    navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()
    navigationItem.title = "TrainTrax"
    if let addImage = UIImage(named: "Add")?.maskedImageWithColor(UIColor.accent) {
      let addButton = UIButton(type: .custom)
      addButton.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
      addButton.setImage(addImage, for: .normal)
      addButton.setImage(addImage, for: .highlighted)
      addButton.frame = CGRect(x: 0, y: 0, width: addImage.size.width, height: addImage.size.height)
      let addItem = UIBarButtonItem(customView: addButton)
      
      navigationItem.rightBarButtonItems = [addItem]
    }
  }
  
  private func setupTable() {
    routineTable.estimatedRowHeight = 75.0
    routineTable.rowHeight = UITableViewAutomaticDimension
  }
  
  // MARK: - Actions
  
  @IBAction func addTapped(_ sender: AnyObject) {
    let controller = EditRoutineViewController.createControllerFor(routine: nil)
    let navController = UINavigationController(rootViewController: controller)
    self.present(navController, animated: true, completion: nil)
  }
  
}

extension RoutineListViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return RoutineList.shared.list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let routineCell: RoutineListCell = tableView.dequeueReusableCell(withIdentifier: RoutineListCellId, for: indexPath as IndexPath) as! RoutineListCell
    let routine = RoutineList.shared.list[indexPath.row]
    routineCell.routineLabel.text = routine.name
    if routine.completionCount == 1 {
      routineCell.completionLabel.text = "Completed 1 time"
    } else {
      routineCell.completionLabel.text = "Completed \(routine.completionCount) times"
    }
    return routineCell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      var list = RoutineList.shared.list
      let routine = list[indexPath.row]
      let alert = UIAlertController(title: "Delete \(routine.name)?", message: "This action cannot be reversed!", preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
        RoutineList.shared.list.remove(at: indexPath.row)
        RoutineList.shared.saveToCache()
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
      alert.addAction(cancelAction)
      alert.addAction(deleteAction)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let routine = RoutineList.shared.list[indexPath.row]
    let controller = RoutineViewController.createControllerFor(routine: routine)
    navigationController?.pushViewController(controller, animated: true)
  }
  
}
