//
//  OnboardingOnboardingInitializer.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit

class OnboardingModuleInitializer: NSObject {

    let onboardingViewController: OnboardingViewController

    override init() {
        self.onboardingViewController = OnboardingViewController(nibName: "OnboardingViewController", bundle: nil)
    }

}
