//
//  OnboardingOnboardingConfigurator.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit

class OnboardingModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? OnboardingViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: OnboardingViewController) {

        let router = OnboardingRouter()
        router.output = viewController

        let presenter = OnboardingPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = OnboardingInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
