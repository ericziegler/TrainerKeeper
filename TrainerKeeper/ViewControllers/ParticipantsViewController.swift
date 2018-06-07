//
//  ParticipantsViewController.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 6/7/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let ParticipantsViewId = "ParticipantsViewId"

// MARK: - Protocols

protocol ParticipantsViewControllerDelegate {
 
  func didAddParticipantsFor(participantsViewController: ParticipantsViewController, routine: Routine)
  
}

class ParticipantsViewController: UIViewController {

  // MARK: - Properties
  
  @IBOutlet var participantTable: UITableView!
  
  var routine: Routine!
  var delegate: ParticipantsViewControllerDelegate?
  
  // MARK: - Init
  
  class func createControllerFor(routine: Routine) -> ParticipantsViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: ParticipantsViewController = storyboard.instantiateViewController(withIdentifier: ParticipantsViewId) as! ParticipantsViewController
    viewController.routine = routine
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavBar()
    setupTable()
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
    
    if let goImage = UIImage(named: "Check")?.maskedImageWithColor(UIColor.accent) {
      let goButton = UIButton(type: .custom)
      goButton.addTarget(self, action: #selector(goTapped(_:)), for: .touchUpInside)
      goButton.setImage(goImage, for: .normal)
      goButton.setImage(goImage, for: .highlighted)
      goButton.frame = CGRect(x: 0, y: 0, width: goImage.size.width, height: goImage.size.height)
      let goItem = UIBarButtonItem(customView: goButton)
      navigationItem.rightBarButtonItem = goItem
    }
    
    navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()
    navigationItem.title = "Add Participants"
  }
  
  private func setupTable() {
    participantTable.estimatedRowHeight = 80.0
    participantTable.rowHeight = UITableViewAutomaticDimension
    participantTable.allowsSelectionDuringEditing = true
  }
  
  // MARK: - Actions
  
  @IBAction func closeTapped(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func goTapped(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
    if let delegate = delegate {
      delegate.didAddParticipantsFor(participantsViewController: self, routine: routine)
    }
  }
  
  // MARK - Alerts
  
  func displayParticipantAlertWith(name: String?) {
    var index = -1
    if let name = name, let participantIndex = routine.participants.index(of: name) {
      index = participantIndex
    }
    let alert = UIAlertController(title: "Add Participant", message: nil, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
      if let textField = alert.textFields?.first, let participant = textField.text {
        if index > -1 {
          self.routine.participants[index] = participant
        } else {
          self.addParticipant(participant: participant)
        }
        self.participantTable.reloadData()
      }
    }
    alert.addAction(cancelAction)
    alert.addAction(addAction)
    alert.addTextField { (textField) in
      textField.placeholder = "Participant Name"
      textField.text = name
      textField.delegate = self
      textField.returnKeyType = .done
      textField.autocapitalizationType = .words
    }
    self.present(alert, animated: true, completion: nil)
  }
  
  private func addParticipant(participant: String) {
    if routine.participants.contains(participant) {
      let alert = UIAlertController(title: "Participant Already Exists", message: "A participant with this name already exists. Participant names must be unique.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    } else {
      routine.participants.append(participant)
    }
  }
  
}

extension ParticipantsViewController: UITextFieldDelegate {
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
  
}

extension ParticipantsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return routine.participants.count
    } else {
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let participantCell: ParticipantCell = tableView.dequeueReusableCell(withIdentifier: ParticipantCellId, for: indexPath) as! ParticipantCell
      let participant = routine.participants[indexPath.row]
      participantCell.nameLabel.text = participant
      return participantCell
    } else {
      let addCell: AddParticipantCell = tableView.dequeueReusableCell(withIdentifier: AddParticipantCellId, for: indexPath as IndexPath) as! AddParticipantCell
      addCell.delegate = self
      return addCell
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      if editingStyle == .delete {
        self.routine.participants.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
    }
  }
  
}

extension ParticipantsViewController: AddParticipantCellDelegate {

  func addParticipantTappedFor(cell: AddParticipantCell) {
    displayParticipantAlertWith(name: nil)
  }
  
}
