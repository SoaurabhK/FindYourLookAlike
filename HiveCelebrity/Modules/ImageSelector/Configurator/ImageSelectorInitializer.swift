//
//  ImageSelectorImageSelectorInitializer.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit

class ImageSelectorModuleInitializer: NSObject {

    let imageselectorViewController: ImageSelectorViewController

    override init() {
        self.imageselectorViewController = ImageSelectorViewController(nibName: "ImageSelectorViewController", bundle: nil)
        ImageSelectorModuleConfigurator().configureModuleForViewInput(viewInput: imageselectorViewController)
    }
}
