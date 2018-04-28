//
//  UIColor+Extensions.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 11/8/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

extension UIColor {

  convenience init(hex: Int, alpha: CGFloat = 1.0) {
    let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
    let g = CGFloat((hex & 0x00FF00) >> 08) / 255.0
    let b = CGFloat((hex & 0x0000FF) >> 00) / 255.0
    self.init(red:r, green:g, blue:b, alpha:alpha)
  }
  
  convenience init(integerRed red: Int, green: Int, blue: Int, alpha: Int = 255) {
    let r = CGFloat(red) / 255.0
    let g = CGFloat(green) / 255.0
    let b = CGFloat(blue) / 255.0
    let a = CGFloat(alpha) / 255.0
    self.init(red:r, green:g, blue:b, alpha:a)
  }
  
  class var accent: UIColor {
    return UIColor(hex: 0xee753f)
  }
  
  class var navBar: UIColor {
    return UIColor(hex: 0xeeeeee)
  }
  
  class var navBarTitle: UIColor {
    return UIColor(hex: 0x173f78)
  }
  
}
