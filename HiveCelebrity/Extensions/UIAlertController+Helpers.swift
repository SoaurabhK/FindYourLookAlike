//
//  UIAlertController+Helpers.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 28/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import UIKit

struct ActionInterface {
    var title: String = ""
    var style: UIAlertActionStyle = .default

    init(title: String, style: UIAlertActionStyle = .default) {
        self.title = title
        self.style = style
    }
}

extension ActionInterface: Equatable {
    public static func ==(lhs: ActionInterface, rhs: ActionInterface) -> Bool {
        return lhs.title == rhs.title
    }
}

typealias AlertHandler = (ActionInterface) -> Void

extension UIAlertController {
    static func alertController(title: String?,
                                message: String,
                                actionInterfaceList: [ActionInterface],
                                handler: @escaping AlertHandler) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for actionInterface in actionInterfaceList {
            let button = UIAlertAction(title: actionInterface.title, style: actionInterface.style, handler:
            { (action: UIAlertAction) -> Void in
                handler(actionInterface)
            })
            alertController.addAction(button)
        }
        return alertController
    }
}

