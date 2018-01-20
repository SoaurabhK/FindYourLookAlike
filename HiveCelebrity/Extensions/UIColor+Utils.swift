//
//  UIColor+Utils.swift
//  Chatous
//
//  Created by Soaurabh Kakkar on 15/02/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation

extension UIColor {

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }

    convenience init(hexString: String) {
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}

struct Color {
    static let duckEggBlue = UIColor.init(r: 227.0, g: 237.0, b: 250.0)
    static let darkGreyBlue = UIColor.init(r: 57.0, g: 70.0, b: 100.0)
    static let appTextTertiaryBlue = UIColor.init(r: 92.0, g: 118.0, b: 177.0)
    static let primaryDark = UIColor.init(r: 52.0, g: 62.0, b: 85.0)
    static let textGrey = UIColor.init(r: 183.0, g: 183.0, b: 183.0)
    static let underLineGrey = UIColor.init(r: 228.0, g: 228.0, b: 228.0)
}
