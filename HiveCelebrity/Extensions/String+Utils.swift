//
//  String+Utils.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 10/01/18.
//  Copyright © 2018 Soaurabh Kakkar. All rights reserved.
//

import Foundation

extension String {
    var isBlank: Bool {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    public var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    public var isValidPhoneNumber: Bool {
//        let emailRegex = "^((\\+)|(00))[0-9]{6,14}$"
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
//        return emailTest.evaluate(with: self)
        return true 
    }
}

protocol StringProtocol {
    var asString: String { get }
}

extension String: StringProtocol {
    var asString: String { return self }
}

extension Optional where Wrapped : StringProtocol {
    var safeValue: String {
        if case let .some(value) = self {
            return value.asString
        }
        return ""
    }
}
