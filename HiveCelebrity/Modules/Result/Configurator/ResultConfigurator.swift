//
//  ResultResultConfigurator.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 26/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit

class ResultModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController,
                                                       originalImageData: Data,
                                                       celebritiesInfo: [CelebrityInfo],
                                                       celebrityPresent: Bool) {
        if let viewController = viewInput as? ResultViewController {
            configure(viewController: viewController,
                      originalImageData: originalImageData,
                      celebritiesInfo: celebritiesInfo,
                      celebrityPresent: celebrityPresent)
        }
    }

    private func configure(viewController: ResultViewController,
                           originalImageData: Data,
                           celebritiesInfo: [CelebrityInfo],
                           celebrityPresent: Bool) {

        let dataModel = ResultsDataModel(originalImageData: originalImageData, celebritiesInfo: celebritiesInfo)
        dataModel.celebrityPresent = celebrityPresent
        let router = ResultRouter()
        router.output = viewController
        
        let presenter = ResultPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.dataModel = dataModel

        let interactor = ResultInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }
}
