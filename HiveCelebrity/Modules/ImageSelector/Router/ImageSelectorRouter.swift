//
//  ImageSelectorImageSelectorRouter.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit

class ImageSelectorRouter: ImageSelectorRouterInput {
    weak var output: ImageSelectorRouterOutput!

    func showResultModuleWithOriginalImageData(_ originalImageData: Data,
                                               celebritiesInfo: [CelebrityInfo],
                                               celebrityPresent: Bool){
        let initialiser = ResultModuleInitializer(originalImageData: originalImageData,
                                                  celebritiesInfo: celebritiesInfo,
                                                  celebrityPresent: celebrityPresent)
        self.output.push(viewController: initialiser.resultViewController)
    }

    func moveToAppPhoneSettings() {
        GlobalHelpers.openPhoneSettings()
    }
}
