//
//  NSMutableData+Extensions.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 02/01/18.
//  Copyright © 2018 Soaurabh Kakkar. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return }
        append(data)
    }
}
