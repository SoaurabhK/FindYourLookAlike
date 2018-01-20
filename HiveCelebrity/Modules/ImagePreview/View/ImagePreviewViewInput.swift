//
//  ImagePreviewImagePreviewViewInput.swift
//  hive-celebrity-ios
//
//  Created by cd /Users/Soaurabh/WORK/Xcode/HiveCelebrity/Templates on 28/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

protocol ImagePreviewViewInput: class {

    /**
        @author cd /Users/Soaurabh/WORK/Xcode/HiveCelebrity/Templates
        Setup initial state of the view
    */

    func setupInitialState()
    func updateImageWithData(data: Data)
}
