//
//  HiveEnterpriseHiveEnterpriseViewOutput.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 10/01/2018.
//  Copyright © 2018 Hive. All rights reserved.
//

protocol HiveEnterpriseViewOutput {

    /**
        @author Soaurabh Kakkar
        Notify presenter that view is ready
    */

    func viewIsReady()
    func backTapped()
    func sendFeedbackTapped()
    func updateData(withString value: String?, textFieldType: FormTextFieldType)
    func updateMessage(message: String?)
    var messageCharacterLimit: Int { get }
}
