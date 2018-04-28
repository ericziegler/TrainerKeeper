//
//  StyleUI.swift
//  TrainerKeeper
//
//  Created by Eric Ziegler on 11/8/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

// MARK: Global Properties

func applyApplicationAppearanceProperties() {
//  UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : UIFont.applicationFontOfSize(17)], for: UIControlState())
  UINavigationBar.appearance().tintColor = UIColor.accent
  UINavigationBar.appearance().barTintColor = UIColor.navBar
  //UITabBar.appearance().tintColor = UIColor.accent
//  UITabBar.appearance().barTintColor = UIColor.tabBar
//  UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : UIFont.applicationFontOfSize(14.0), NSAttributedStringKey.foregroundColor : UIColor.tabBarNormal], for: .normal)
//  UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : UIFont.applicationFontOfSize(14.0), NSAttributedStringKey.foregroundColor : UIColor.lightAccent], for: .selected)
}

func navTitleTextAttributes() -> [NSAttributedStringKey : Any] {
  return [NSAttributedStringKey.font : UIFont.applicationBoldFontOfSize(21.0), NSAttributedStringKey.foregroundColor : UIColor.navBarTitle]
}

// MARK: Styled Labels

class ApplicationStyleLabel : UILabel {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.preInit();
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.preInit()
  }
  
  func preInit() {
    if let text = self.text, text.hasPrefix("^") {
      self.text = nil
    }
    self.commonInit()
  }
  
  func commonInit() {
    if type(of: self) === ApplicationStyleLabel.self {
      fatalError("ApplicationStyleLabel not meant to be used directly. Use its subclasses.")
    }
  }
}

class RegularLabel: ApplicationStyleLabel {
  override func commonInit() {
    self.font = UIFont.applicationFontOfSize(self.font.pointSize)
  }
}

class BoldLabel: ApplicationStyleLabel {
  override func commonInit() {
    self.font = UIFont.applicationBoldFontOfSize(self.font.pointSize)
  }
}

class LightLabel: ApplicationStyleLabel {
  override func commonInit() {
    self.font = UIFont.applicationLightFontOfSize(self.font.pointSize)
  }
}
