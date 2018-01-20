//
//  HiveEnterpriseHiveEnterprisePresenter.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 10/01/2018.
//  Copyright © 2018 Hive. All rights reserved.
//


enum LoaderState {
    case visible, hidden
}

enum FormTextFieldType {
    case name, email, company, phone
    
    var errorMessage: String? {
        switch self {
        case .name:
            return "Please enter your name"
        case .email:
            return "Please enter a valid email id"
        case .phone:
            return "Please enter a valid phone number"
        case .company:
            return nil
        }
    }
    
    var placeholder: String {
        switch self {
        case .name:
            return "Please enter your name"
        case .email:
            return "Please enter your email id"
        case .company:
            return "Company (optional)"
        case .phone:
            return "Phone Number (optional)"
        }
    }
    
    var title: String {
        switch self {
        case .name:
            return "Name"
        case .email:
            return "Email Id"
        case .company:
            return "Company (optional)"
        case .phone:
            return "Phone Number (optional)"
        }
    }
    
    var characterLimit: Int? {
        switch self {
        case .name:
            return 50
        case .email:
            return nil
        case .company:
            return 500
        case .phone:
            return 14
        }
    }
}

enum TextFieldValidityState {
    case valid(FormTextFieldType)
    case invalid(FormTextFieldType)
}

class HiveEnterprisePresenter: HiveEnterpriseModuleInput {

    weak var view: HiveEnterpriseViewInput!
    var interactor: HiveEnterpriseInteractorInput!
    var router: HiveEnterpriseRouterInput!
    
    var name: String? = ""
    var email: String? = ""
    var companyName: String?
    var phoneString: String? = ""
    var message: String?
    
    func checkFormValidity() -> Bool {
        guard self.checkNameValidity() && self.checkEmailValidity() && self.checkPhoneValidity() && !self.isFormEmpty() else {
            return false
        }
        return true
    }
    
    func checkNameValidity() -> Bool {
        if let nameString = name, nameString.isBlank {
            self.view.toggleTextFieldValidity(withState: .invalid(.name))
            return false
        }
        self.view.toggleTextFieldValidity(withState: .valid(.name))
        return true
    }
    func checkEmailValidity() -> Bool {
        if let emailString = email, !emailString.isValidEmail || emailString.isBlank {
            self.view.toggleTextFieldValidity(withState: .invalid(.email))
            return false
        }
        self.view.toggleTextFieldValidity(withState: .valid(.email))
        return true
    }
    func checkPhoneValidity() -> Bool {
        if let phone = phoneString, !phone.isValidPhoneNumber && !phone.isBlank {
            self.view.toggleTextFieldValidity(withState: .invalid(.phone))
            return false
        }
        self.view.toggleTextFieldValidity(withState: .valid(.phone))
        return true
    }
    func isFormEmpty() -> Bool {
        return self.name.safeValue.isBlank || self.email.safeValue.isBlank
    }
}

extension HiveEnterprisePresenter: HiveEnterpriseViewOutput {
    func viewIsReady() {
        self.view.setupInitialState()
    }
    
    func backTapped() {
        self.router.takeToPreviousScreen()
    }
    
    func sendFeedbackTapped() {
        if self.checkFormValidity() {
            self.view.toggleLoaderVisiblity(forState: .visible)
            self.interactor.sendFeedback(withName: self.name.safeValue, email: self.email.safeValue, company: self.companyName, phone: self.phoneString, message: self.message.safeValue)
        }
    }
    
    func updateMessage(message: String?) {
        self.message = message.safeValue
    }
    
    func updateData(withString value: String?, textFieldType type: FormTextFieldType) {
        switch type {
        case .name:
            self.name = value.safeValue
            let _ = self.checkNameValidity()
        case .email:
            self.email = value
            let _ = self.checkEmailValidity()
        case .company:
            let _ = self.companyName = value
        case .phone:
            self.phoneString = value
            let _ = self.checkPhoneValidity()
        }
    }
    
    var messageCharacterLimit: Int {
        return 4000
    }
}

extension HiveEnterprisePresenter: HiveEnterpriseInteractorOutput {
    func errorInSendingFeedback(error: Error?) {
        self.view.toggleLoaderVisiblity(forState: .hidden)
    }
    
    func feedbackSentSuccessfully() {
        self.view.toggleLoaderVisiblity(forState: .hidden)
        self.router.takeToPreviousScreen()
    }
}
