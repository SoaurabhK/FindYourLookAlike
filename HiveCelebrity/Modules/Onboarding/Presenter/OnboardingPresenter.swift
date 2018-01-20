//
//  OnboardingOnboardingPresenter.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

class OnboardingPresenter: OnboardingModuleInput, OnboardingInteractorOutput {

    weak var view: OnboardingViewInput!
    var interactor: OnboardingInteractorInput!
    var router: OnboardingRouterInput!

}

extension OnboardingPresenter: OnboardingViewOutput {
    func viewIsReady() {
        
    }
    
    func getStartedTapped() {
        self.router.showImageSelectorModule()
    }

    func termsAndConditionsTapped() {
        guard let url = URL(string: WebLinks.termsAndConditions) else { return }
        self.router.presentWebPage(url: url)
    }

    func privacyPolicyTapped() {
        guard let url = URL(string: WebLinks.privacyPolicy) else { return }
        self.router.presentWebPage(url: url)
    }
}
