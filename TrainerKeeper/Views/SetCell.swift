//
//  SetCell.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 4/27/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let SetCellId = "SetCellId"

class SetCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  @IBOutlet var nameLabel: RegularLabel!
  @IBOutlet var completedView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderColor = UIColor(hex: 0xcccccc).cgColor
    self.layer.borderWidth = 1.0
  }
  
}
