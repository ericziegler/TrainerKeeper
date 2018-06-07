//
//  AddParticipantCell.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 6/7/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let AddParticipantCellId = "AddParticipantCellId"

// MARK: - Protocols

protocol AddParticipantCellDelegate {
  func addParticipantTappedFor(cell: AddParticipantCell)
}

class AddParticipantCell: UITableViewCell {
  
  // MARK: - Properties
  
  var delegate: AddParticipantCellDelegate?
  
  @IBAction func addParticipantTapped(_ sender: AnyObject) {
    if let delegate = delegate {
      delegate.addParticipantTappedFor(cell: self)
    }
  }
  
}
