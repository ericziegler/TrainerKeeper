//
//  AddSetCell.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 4/26/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let AddSetCellId = "AddSetCellId"

// MARK: - Protocols

protocol AddSetCellDelegate {
  func addSetTappedFor(cell: AddSetCell)
}

class AddSetCell: UITableViewCell {
  
  // MARK: - Properties
  
  var delegate: AddSetCellDelegate?
  
  @IBAction func addSetTapped(_ sender: AnyObject) {
    if let delegate = delegate {
      delegate.addSetTappedFor(cell: self)
    }
  }
  
}
