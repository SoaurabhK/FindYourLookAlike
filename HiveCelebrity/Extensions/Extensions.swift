//
//  Extensions.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 02/01/18.
//  Copyright © 2018 Soaurabh Kakkar. All rights reserved.
//

import Foundation

func DLOG(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        print(items[0], separator: separator, terminator: terminator)
    #endif
}
