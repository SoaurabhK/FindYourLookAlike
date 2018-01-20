//
//  HiveEnterpriseHiveEnterpriseInteractorOutput.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 10/01/2018.
//  Copyright © 2018 Hive. All rights reserved.
//

import Foundation

protocol HiveEnterpriseInteractorOutput: class {
    func errorInSendingFeedback(error: Error?)
    func feedbackSentSuccessfully()
}
