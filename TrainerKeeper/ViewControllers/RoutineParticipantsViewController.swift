//
//  RoutineParticipantsViewController.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 6/7/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let RoutineParticipantsViewId = "RoutineParticipantsViewId"

// MARK: - Protocols

protocol RoutineParticipantsViewControllerDelegate {
  
  func participantToggleSetFor(routineParticipantsViewController: RoutineParticipantsViewController, routineSet: RoutineSet, participant: String?)
  
}

class RoutineParticipantsViewController: UIViewController {

  // MARK: Properties
  
  @IBOutlet var participantTable: UITableView!
  @IBOutlet var tableBackground: UIView!
  
  var routine: Routine!
  var routineSet: RoutineSet!
  var delegate: RoutineParticipantsViewControllerDelegate?
  
  // MARK: - Init
  
  class func createControllerFor(routine: Routine, routineSet: RoutineSet) -> RoutineParticipantsViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: RoutineParticipantsViewController = storyboard.instantiateViewController(withIdentifier: RoutineParticipantsViewId) as! RoutineParticipantsViewController
    viewController.routine = routine
    viewController.routineSet = routineSet
    return viewController
  }
  
  func addToParent(parentViewController: UIViewController, container: UIView) {
    self.willMove(toParentViewController: parentViewController)
    parentViewController.addChildViewController(self)
    container.addSubview(self.view)
    self.didMove(toParentViewController: parentViewController)
    self.view.translatesAutoresizingMaskIntoConstraints = false
    
    container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[participantView]|", options: [], metrics: nil, views: ["participantView" : self.view]))
    container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[participantView]|", options: [], metrics: nil, views: ["participantView" : self.view]))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTable()
    self.tableBackground.layer.cornerRadius = 6.0
  }
  
  private func setupTable() {
    participantTable.estimatedRowHeight = 44.0
    participantTable.rowHeight = UITableViewAutomaticDimension
  }
  
  // MARK - Actions
  
  @IBAction func cancelTapped(_ sender: AnyObject) {
    if let delegate = delegate {
      delegate.participantToggleSetFor(routineParticipantsViewController: self, routineSet: routineSet, participant: nil)
    }
  }
  
}

extension RoutineParticipantsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return routine.participants.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let routineParticipantCell: RoutineParticipantCell = tableView.dequeueReusableCell(withIdentifier: RoutineParticipantCellId, for: indexPath) as! RoutineParticipantCell
    let participant = routine.participants[indexPath.row]
    routineParticipantCell.nameLabel.text = participant
    if routineSet.participantsCompleted.contains(participant) {
      routineParticipantCell.checkImageView.isHidden = false
    } else {
      routineParticipantCell.checkImageView.isHidden = true
    }
    return routineParticipantCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var participant: String?
    participant = routine.participants[indexPath.row]
    if let delegate = delegate {
      delegate.participantToggleSetFor(routineParticipantsViewController: self, routineSet: routineSet, participant: participant)
    }
  }
  
}
