//
//  HiveEnterpriseHiveEnterpriseInteractor.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 10/01/2018.
//  Copyright © 2018 Hive. All rights reserved.
//

class HiveEnterpriseInteractor: HiveEnterpriseInteractorInput {

    weak var output: HiveEnterpriseInteractorOutput!

    func sendFeedback(withName name: String, email: String, company: String?, phone: String?, message: String) {
        var dataDict: [String: String] = [:]
        dataDict["name"] = name
        dataDict["email"] = email
        dataDict["message"] = message
        if let companyName = company {
            dataDict["company"] = companyName
        }
        if let phoneString = phone {
            dataDict["phone"] = phoneString
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: dataDict, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        HiveAPIInterface.sharedInterface.sendFeedback(data: jsonData) {  (result: Result<SuccessResponse>) in
            DispatchQueue.main.async { [weak self] in
                if let _ = result.data {
                    self?.output.feedbackSentSuccessfully()
                } else {
                    self?.output.errorInSendingFeedback(error: result.error)
                }
            }
        }
    }
}
