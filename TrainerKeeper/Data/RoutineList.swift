//
//  RoutineList.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 4/24/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import Foundation

// MARK: - Constants

let RoutineListCacheKey = "RoutineListCacheKey"

class RoutineList {

  // MARK: - Properties
  
  var list = [Routine]()
  
  // MARK: - Init
  
  static let shared = RoutineList()
  
  init() {
    loadFromCache()
  }
  
  // MARK: - Save / Load
  
  func loadFromCache() {
    if let data = UserDefaults.standard.data(forKey: RoutineListCacheKey) {
      if let tempList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Routine] {
        self.list = tempList
      }
    }
  }
  
  func saveToCache() {
    let data = NSKeyedArchiver.archivedData(withRootObject: self.list)
    UserDefaults.standard.set(data, forKey: RoutineListCacheKey)
    UserDefaults.standard.synchronize()
  }
  
}
