//
//  Routine.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 4/25/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import Foundation

// MARK: - Constants

let RoutineNameCacheKey = "RoutineNameCacheKey"
let RoutineSetsCacheKey = "RoutineSetsCacheKey"
let RoutineCompletionCountCacheKey = "RoutineCompletionCountCacheKey"

class Routine: NSObject, NSCoding {

  // MARK: - Properties
  
  var name = ""
  var routineSets = [RoutineSet]()
  var completionCount = 0
  
  // MARK: - Init
  
  override init() {
    super.init()
  }
  
  // MARK: - NSCoding
  
  required init?(coder decoder: NSCoder) {
    if let name = decoder.decodeObject(forKey: RoutineNameCacheKey) as? String {
      self.name = name
    }
    if let setData = decoder.decodeObject(forKey: RoutineSetsCacheKey) as? Data {
      if let routineSets = NSKeyedUnarchiver.unarchiveObject(with: setData) as? [RoutineSet] {
        self.routineSets = routineSets
      }
    }
    if let completionNumber = decoder.decodeObject(forKey: RoutineCompletionCountCacheKey) as? NSNumber {
      self.completionCount = completionNumber.intValue
    }
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(self.name, forKey: RoutineNameCacheKey)
    let data = NSKeyedArchiver.archivedData(withRootObject: self.routineSets)
    coder.encode(data, forKey: RoutineSetsCacheKey)
    coder.encode(NSNumber(integerLiteral: self.completionCount), forKey: RoutineCompletionCountCacheKey)
  }

  
}
