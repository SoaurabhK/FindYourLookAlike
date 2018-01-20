//
//  HiveEnterpriseHiveEnterpriseInteractorInput.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 10/01/2018.
//  Copyright © 2018 Hive. All rights reserved.
//

import Foundation

protocol HiveEnterpriseInteractorInput {
    func sendFeedback(withName: String, email: String, company: String?, phone: String?, message: String)
}
