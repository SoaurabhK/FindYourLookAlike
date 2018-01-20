//
//  UIViewController+Alerts.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 28/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String? = nil, message: String) {
        let okAction = ActionInterface(title: "Ok")
        let alertController = UIAlertController.alertController(title: title,
                                                                message: message,
                                                                actionInterfaceList: [okAction],
                                                                handler: { _ in
        })
        present(alertController, animated: true, completion: nil)
    }

    func showAlert(error: NSError) {
        showAlert(title: "", message: (error.userInfo[NSLocalizedDescriptionKey] as? String) ?? error.localizedDescription)
    }

    func showErrorAlert(title: String = "Error", message: String) {
        showAlert(title: title, message: message)
    }

    func showAlert(title: String, message: String, actionInterfaceList: [ActionInterface], handler: @escaping AlertHandler) {
        let alertController =  UIAlertController.alertController(title: title,
                                                                 message: message,
                                                                 actionInterfaceList: actionInterfaceList,
                                                                 handler: handler)
        self.present(alertController, animated: true, completion: nil)
    }
}

