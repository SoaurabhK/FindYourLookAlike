//
//  HiveEnterpriseHiveEnterpriseViewInput.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 10/01/2018.
//  Copyright © 2018 Hive. All rights reserved.
//

protocol HiveEnterpriseViewInput: class {

    /**
        @author Soaurabh Kakkar
        Setup initial state of the view
    */

    func setupInitialState()
    func toggleLoaderVisiblity(forState: LoaderState)
    func feedbackResponseSuccess()
    func feedbackResponseFailure(error: Error?)
    func toggleTextFieldValidity(withState: TextFieldValidityState)
}
