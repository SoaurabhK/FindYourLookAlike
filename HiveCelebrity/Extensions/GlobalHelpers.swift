//
//  GlobalHelpers.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 28/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import UIKit

class GlobalHelpers {
    class func openPhoneSettings() {
        guard let url = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
