//
//  OnboardingRouterOutput.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 20/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import UIKit

protocol OnboardingRouterOutput: class {
    func push(viewController: UIViewController)
    func present(viewController: UIViewController, completion: (()->Void)?)
}
