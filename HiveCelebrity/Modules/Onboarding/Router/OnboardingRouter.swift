//
//  OnboardingOnboardingRouter.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import SafariServices

class OnboardingRouter: OnboardingRouterInput {
    
    weak var output: OnboardingRouterOutput!
    
    func showImageSelectorModule() {
        let initialiser = ImageSelectorModuleInitializer()
        self.output.push(viewController: initialiser.imageselectorViewController)
    }


    func presentWebPage(url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        self.output.present(viewController: safariViewController, completion: nil)
    }
}
