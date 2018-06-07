//
//  EditRoutineViewController.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 4/26/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let EditRoutineViewId = "EditRoutineViewId"

class EditRoutineViewController: UIViewController {

  // MARK: - Properties
  
  @IBOutlet var editTable: UITableView!
  
  var routine: Routine!
  var isNewRoutine = false
  
  // MARK: - Init
  
  class func createControllerFor(routine: Routine?) -> EditRoutineViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: EditRoutineViewController = storyboard.instantiateViewController(withIdentifier: EditRoutineViewId) as! EditRoutineViewController
    if let routine = routine {
      viewController.routine = routine
    } else {
      viewController.routine = Routine()
      viewController.isNewRoutine = true
    }
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavBar()
    setupTable()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    editTable.reloadData()
    editTable.alpha = 0.0
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    editTable.scrollToRow(at: IndexPath(row: 0, section: 2), at: .bottom, animated: false)
    UIView.animate(withDuration: 0.1) {
      self.editTable.alpha = 1.0
    }
  }
  
  private func setupNavBar() {
    navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()
    if isNewRoutine {
      navigationItem.title = "New Routine"
    } else {
      navigationItem.title = "Edit Routine"
    }
    
    if let saveImage = UIImage(named: "Check")?.maskedImageWithColor(UIColor.accent) {
      let saveButton = UIButton(type: .custom)
      saveButton.addTarget(self, action: #selector(saveTapped(_:)), for: .touchUpInside)
      saveButton.setImage(saveImage, for: .normal)
      saveButton.setImage(saveImage, for: .highlighted)
      saveButton.frame = CGRect(x: 0, y: 0, width: saveImage.size.width, height: saveImage.size.height)
      let saveItem = UIBarButtonItem(customView: saveButton)      
      navigationItem.rightBarButtonItem = saveItem
    }
    
    if let closeImage = UIImage(named: "Close")?.maskedImageWithColor(UIColor.accent) {
      let closeButton = UIButton(type: .custom)
      closeButton.addTarget(self, action: #selector(closeTapped(_:)), for: .touchUpInside)
      closeButton.setImage(closeImage, for: .normal)
      closeButton.setImage(closeImage, for: .highlighted)
      closeButton.frame = CGRect(x: 0, y: 0, width: closeImage.size.width, height: closeImage.size.height)
      let closeItem = UIBarButtonItem(customView: closeButton)
      navigationItem.leftBarButtonItem = closeItem
    }
  }
  
  private func setupTable() {
    editTable.estimatedRowHeight = 80.0
    editTable.rowHeight = UITableViewAutomaticDimension
    editTable.isEditing = true
    editTable.allowsSelectionDuringEditing = true
  }
  
  @IBAction func saveTapped(_ sender: AnyObject) {
    if !routine.name.isEmpty && routine.routineSets.count > 0 {
      if isNewRoutine {
        RoutineList.shared.list.append(routine)
      }
      RoutineList.shared.saveToCache()
      self.dismiss(animated: true, completion: nil)
    } else {
      let alert = UIAlertController(title: "Cannot Save", message: "A routine must have a name and at least one set.", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
        self.dismiss(animated: true, completion: nil)
      }
      alert.addAction(okAction)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  @IBAction func closeTapped(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Cancel Changes", message: "Are you sure you would like to cancel any changes that you've made?", preferredStyle: .alert)
    let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
    let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
      self.dismiss(animated: true, completion: nil)
    }
    alert.addAction(noAction)
    alert.addAction(yesAction)
    self.present(alert, animated: true, completion: nil)
  }
  
}

extension EditRoutineViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else if section == 1 {
      return routine.routineSets.count
    } else {
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let nameCell: EditRoutineNameCell = tableView.dequeueReusableCell(withIdentifier: EditRoutineNameCellId, for: indexPath as IndexPath) as! EditRoutineNameCell
      nameCell.nameTextField.text = routine?.name
      return nameCell
    }
    else if indexPath.section == 1 {
      let editCell: EditSetCell = tableView.dequeueReusableCell(withIdentifier: EditSetCellId, for: indexPath as IndexPath) as! EditSetCell
      let routineSet = routine.routineSets[indexPath.row]
      editCell.nameLabel.text = routineSet.name
      editCell.repLabel.text = "\(routineSet.repetitions)x"
      return editCell
    } else {
      let addCell: AddSetCell = tableView.dequeueReusableCell(withIdentifier: AddSetCellId, for: indexPath as IndexPath) as! AddSetCell
      addCell.delegate = self
      addCell.totalRepLabel.text = "Total Reps: \(routine.totalRepCount)"
      return addCell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      self.view.endEditing(true)
      let routineSet = routine.routineSets[indexPath.row]
      let controller = EditSetViewController.createControllerFor(routine: routine, routineSet: routineSet)
      controller.delegate = self
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if indexPath.section == 1 && editingStyle == .delete {
      routine.routineSets.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .none
  }
  
  func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section == 1 {
      return true
    }
    return false
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section == 1 {
      return true
    }
    return false
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    if sourceIndexPath.section == 1 {
      let source = sourceIndexPath.row
      let destination = destinationIndexPath.row
      let routineSet = routine.routineSets[source]
      routine.routineSets.remove(at: source)
      routine.routineSets.insert(routineSet, at: destination)
    }
  }
  
}

extension EditRoutineViewController: AddSetCellDelegate {
 
  func addSetTappedFor(cell: AddSetCell) {
    self.view.endEditing(true)
    let controller = EditSetViewController.createControllerFor(routine: routine, routineSet: nil)
    controller.delegate = self
    navigationController?.pushViewController(controller, animated: true)
  }
  
}

extension EditRoutineViewController: EditSetViewControllerDelegate {
 
  func didUpdateSet(routineSet: RoutineSet) {
    editTable.reloadData()
    editTable.scrollToRow(at: IndexPath(row: 0, section: 2), at: .bottom, animated: false)
  }
  
}

extension EditRoutineViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let updatedString = textField.text!.replacingCharacters(in: range.toRange(textField.text!), with: string) as String
    routine.name = updatedString
    return true
  }
  
}
