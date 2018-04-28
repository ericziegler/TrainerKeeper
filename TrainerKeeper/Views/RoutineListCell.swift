//
//  RoutineListCell.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 4/26/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let RoutineListCellId = "RoutineListCellId"

class RoutineListCell: UITableViewCell {

  // MARK: - Properties
  
  @IBOutlet var routineLabel: RegularLabel!
  @IBOutlet var completionLabel: LightLabel!
  
}
