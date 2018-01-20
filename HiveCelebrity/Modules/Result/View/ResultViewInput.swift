//
//  ResultResultViewInput.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 26/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

protocol ResultViewInput: class {

    /**
        @author Soaurabh Kakkar
        Setup initial state of the view
    */

    func setupInitialState()
    func configureForSinglePage()
    func shareImageToFb(imageData: Data)
    func shareResults(imageData: Data)
    func showShareButtons(show: Bool)
}
