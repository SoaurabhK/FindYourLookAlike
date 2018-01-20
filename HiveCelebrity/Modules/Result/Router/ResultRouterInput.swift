//
//  ResultResultRouterInput.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 26/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import Foundation

protocol ResultRouterInput {
    func takeBackToPreviousScreen()
    func showOriginalImageModule(imageData: Data)
    func showHiveEnterpriseModule()
}
