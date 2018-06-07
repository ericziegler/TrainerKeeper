//
//  EditSetViewController.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 4/27/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let EditSetViewId = "EditSetViewId"

protocol EditSetViewControllerDelegate {
 
  func didUpdateSet(routineSet: RoutineSet)
  
}

class EditSetViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var repTextField: UITextField!
  @IBOutlet var deleteButon: UIButton!
  
  var routine: Routine!
  var routineSet: RoutineSet!
  var isNewSet = false
  var delegate: EditSetViewControllerDelegate?
  
  // MARK: - Init
  
  class func createControllerFor(routine: Routine, routineSet: RoutineSet?) -> EditSetViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: EditSetViewController = storyboard.instantiateViewController(withIdentifier: EditSetViewId) as! EditSetViewController
    viewController.routine = routine
    if let routineSet = routineSet {
      viewController.routineSet = routineSet
    } else {
      viewController.routineSet = RoutineSet()
      viewController.isNewSet = true
    }
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    nameTextField.text = routineSet.name
    if routineSet.repetitions > 0 {
      repTextField.text = String(routineSet.repetitions)
    }
    setupNavBar()
    if routineSet.name.isEmpty {
      deleteButon.isHidden = true
    } else {
      deleteButon.layer.cornerRadius = 10.0
    }
    nameTextField.becomeFirstResponder()
  }
  
  private func setupNavBar() {
    navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()
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
  
  @IBAction func saveTapped(_ sender: AnyObject) {
    saveSet()
  }
  
  @IBAction func closeTapped(_ sender: AnyObject) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func deleteTapped(_ sender: AnyObject) {
    if let index = routine.routineSets.index(of: routineSet) {
      routine.routineSets.remove(at: index)
    }
    navigationController?.popViewController(animated: true)
  }
  
  private func saveSet() {
    if let name = nameTextField.text, let repText = repTextField.text, let reps = Int(repText) {
      routineSet.name = name
      routineSet.repetitions = reps
    }
    if !routineSet.name.isEmpty && routineSet.repetitions > 0 {
      if isNewSet {
        routine.routineSets.append(routineSet)
      }
      if let delegate = delegate {
        delegate.didUpdateSet(routineSet: routineSet)
      }
      navigationController?.popViewController(animated: true)
    } else {
      let alert = UIAlertController(title: "Cannot Save", message: "A set name and number of reps need to be entered before saving.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
}

extension EditSetViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == nameTextField {
      repTextField.becomeFirstResponder()
    }
    else if textField == repTextField {
      saveSet()
    }
    return true
  }
  
}
