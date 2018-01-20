//
//  ImagePreviewImagePreviewConfigurator.swift
//  hive-celebrity-ios
//
//  Created by cd /Users/Soaurabh/WORK/Xcode/HiveCelebrity/Templates on 28/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit

class ImagePreviewModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController, imageData: Data) {

        if let viewController = viewInput as? ImagePreviewViewController {
            configure(viewController: viewController, imageData: imageData)
        }
    }

    private func configure(viewController: ImagePreviewViewController, imageData: Data) {

        let dataModel = ImagePreviewDataModel(imageData: imageData)

        let router = ImagePreviewRouter()

        let presenter = ImagePreviewPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.dataModel = dataModel

        let interactor = ImagePreviewInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
