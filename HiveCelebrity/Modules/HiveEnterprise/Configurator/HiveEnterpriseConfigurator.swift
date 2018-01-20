//
//  HiveEnterpriseHiveEnterpriseConfigurator.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 10/01/2018.
//  Copyright © 2018 Hive. All rights reserved.
//

import UIKit

class HiveEnterpriseModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? HiveEnterpriseViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: HiveEnterpriseViewController) {

        let router = HiveEnterpriseRouter()
        router.output = viewController
        
        let presenter = HiveEnterprisePresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = HiveEnterpriseInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
