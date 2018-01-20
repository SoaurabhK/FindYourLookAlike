//
//  ImageSelectorImageSelectorConfigurator.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit

class ImageSelectorModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? ImageSelectorViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: ImageSelectorViewController) {

        let router = ImageSelectorRouter()
        router.output = viewController
        
        let presenter = ImageSelectorPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = ImageSelectorInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
