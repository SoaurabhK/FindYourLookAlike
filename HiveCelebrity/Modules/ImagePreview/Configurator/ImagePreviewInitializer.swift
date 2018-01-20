//
//  ImagePreviewImagePreviewInitializer.swift
//  hive-celebrity-ios
//
//  Created by cd /Users/Soaurabh/WORK/Xcode/HiveCelebrity/Templates on 28/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit

class ImagePreviewModuleInitializer: NSObject {

    let imagepreviewViewController: ImagePreviewViewController

    override init() {
        self.imagepreviewViewController = ImagePreviewViewController(nibName: "ImagePreviewViewController", bundle: nil)
        super.init()
    }

    convenience init(imageData: Data) {
        self.init()
        ImagePreviewModuleConfigurator().configureModuleForViewInput(viewInput: imagepreviewViewController, imageData: imageData)
    }
}
