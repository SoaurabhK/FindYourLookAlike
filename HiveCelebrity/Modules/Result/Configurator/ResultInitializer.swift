//
//  ResultResultInitializer.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 26/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit

class ResultModuleInitializer: NSObject {

    let resultViewController: ResultViewController
    
    override init() {
        self.resultViewController = ResultViewController(nibName: "ResultViewController", bundle: nil)
        super.init()

    }

    convenience init(originalImageData: Data,
                     celebritiesInfo: [CelebrityInfo],
                     celebrityPresent: Bool) {
        self.init()
        ResultModuleConfigurator().configureModuleForViewInput(viewInput: resultViewController,
                                                               originalImageData: originalImageData,
                                                               celebritiesInfo: celebritiesInfo,
                                                               celebrityPresent: celebrityPresent)
    }

}
