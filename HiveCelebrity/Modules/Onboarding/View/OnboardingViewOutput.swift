//
//  OnboardingOnboardingViewOutput.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

protocol OnboardingViewOutput {

    /**
        @author Soaurabh Kakkar
        Notify presenter that view is ready
    */

    func viewIsReady()
    func getStartedTapped()
    func privacyPolicyTapped()
    func termsAndConditionsTapped()
}
