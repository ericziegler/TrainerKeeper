//
//  RoutineSet.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 4/25/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import Foundation

// MARK: - Constants

let RoutineSetNameCacheKey = "RoutineSetNameCacheKey"
let RoutineSetRepCacheKey = "RoutineSetRepCacheKey"

class RoutineSet: NSObject, NSCoding {

  // MARK: - Properties
  
  var name = ""
  var repetitions = 0
  var completed = false
  
  // MARK: Init
  
  override init() {
    super.init()
  }
  
  // MARK: - NSCoding
  
  required init?(coder decoder: NSCoder) {
    if let name = decoder.decodeObject(forKey: RoutineSetNameCacheKey) as? String {
      self.name = name
    }
    if let repNumber = decoder.decodeObject(forKey: RoutineSetRepCacheKey) as? NSNumber {
      self.repetitions = repNumber.intValue
    }
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(self.name, forKey: RoutineSetNameCacheKey)
    let repNumber = NSNumber(integerLiteral: self.repetitions)
    coder.encode(repNumber, forKey: RoutineSetRepCacheKey)
  }
  
}
