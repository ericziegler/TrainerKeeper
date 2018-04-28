//
//  TestData.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 4/28/18.
//  Copyright © 2018 zigabytes. All rights reserved.
//

import Foundation

class TestData {

  static let shared = TestData()
  
  init() {
    
  }
  
  func createTestData() {
    RoutineList.shared.list.removeAll()
    RoutineList.shared.saveToCache()
    
    let routine1 = Routine()
    routine1.name = "Punches"
    routine1.completionCount = 17
    
    let set1A = RoutineSet()
    set1A.name = "Left Jabs"
    set1A.repetitions = 25
    routine1.routineSets.append(set1A)
    
    let set1B = RoutineSet()
    set1B.name = "Right Jabs"
    set1B.repetitions = 25
    routine1.routineSets.append(set1B)
    
    let set1C = RoutineSet()
    set1C.name = "Left Crosses"
    set1C.repetitions = 25
    routine1.routineSets.append(set1C)
    
    let set1D = RoutineSet()
    set1D.name = "Right Crosses"
    set1D.repetitions = 25
    routine1.routineSets.append(set1D)
    
    let set1E = RoutineSet()
    set1E.name = "Left Uppercuts"
    set1E.repetitions = 25
    routine1.routineSets.append(set1E)
    
    let set1F = RoutineSet()
    set1F.name = "Right Uppercuts"
    set1F.repetitions = 25
    routine1.routineSets.append(set1F)
    
    let set1G = RoutineSet()
    set1G.name = "Left Hooks"
    set1G.repetitions = 25
    routine1.routineSets.append(set1G)
    
    let set1H = RoutineSet()
    set1H.name = "Right Hooks"
    set1H.repetitions = 25
    routine1.routineSets.append(set1H)
    
    let set1I = RoutineSet()
    set1I.name = "Left Lead Elbow"
    set1I.repetitions = 25
    routine1.routineSets.append(set1I)
    
    let set1J = RoutineSet()
    set1J.name = "Right Lead Elbow"
    set1J.repetitions = 25
    routine1.routineSets.append(set1J)
    
    let set1K = RoutineSet()
    set1K.name = "Left Rear Elbow"
    set1K.repetitions = 25
    routine1.routineSets.append(set1K)
    
    let set1L = RoutineSet()
    set1L.name = "Right Rear Elbow"
    set1L.repetitions = 25
    routine1.routineSets.append(set1L)
    
    let set1M = RoutineSet()
    set1M.name = "Left Uppercut Elbow"
    set1M.repetitions = 25
    routine1.routineSets.append(set1M)
    
    let set1N = RoutineSet()
    set1N.name = "Right Uppercut Elbow"
    set1N.repetitions = 25
    routine1.routineSets.append(set1N)
    
    RoutineList.shared.list.append(routine1)
    
    let routine2 = Routine()
    routine2.name = "Kicks"
    routine2.completionCount = 10
    RoutineList.shared.list.append(routine2)
    
    let routine3 = Routine()
    routine3.name = "Throws"
    routine3.completionCount = 7
    RoutineList.shared.list.append(routine3)
    
    let routine4 = Routine()
    routine4.name = "Core Training"
    routine4.completionCount = 9
    RoutineList.shared.list.append(routine4)
    
    let routine5 = Routine()
    routine5.name = "Pushups & Situps"
    routine5.completionCount = 4
    RoutineList.shared.list.append(routine5)
    
    RoutineList.shared.saveToCache()
  }
  
}
