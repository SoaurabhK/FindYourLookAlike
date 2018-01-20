//
//  ResultRouterOutput.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 26/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import UIKit

protocol ResultRouterOutput: class {
    func push(viewController: UIViewController)
    func popViewController()
    func present(viewController: UIViewController, completion: (()->Void)?)
}
