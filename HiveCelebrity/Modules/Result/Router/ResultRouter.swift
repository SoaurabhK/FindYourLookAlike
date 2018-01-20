//
//  ResultResultRouter.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 26/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

class ResultRouter: ResultRouterInput {
    weak var output: ResultRouterOutput!
    
    func takeBackToPreviousScreen() {
        self.output.popViewController()
    }

    func showOriginalImageModule(imageData: Data) {
        let initialiser = ImagePreviewModuleInitializer.init(imageData: imageData)
        self.output.push(viewController: initialiser.imagepreviewViewController)
    }
    
    func showHiveEnterpriseModule() {
        let initialiser = HiveEnterpriseModuleInitializer()
        self.output.push(viewController: initialiser.hiveEnterpriseViewController)
    }
}
