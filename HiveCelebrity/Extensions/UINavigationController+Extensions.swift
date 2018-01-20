//
//  UINavigationController+Extensions.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 29/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation

extension UINavigationController {
    func makeNavigationBarTransparent() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor.clear
        self.navigationBar.tintColor = UIColor.white
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

