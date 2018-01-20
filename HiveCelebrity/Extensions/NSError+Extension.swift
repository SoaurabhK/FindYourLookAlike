//
//  NSError+Extension.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 02/01/18.
//  Copyright © 2018 Soaurabh Kakkar. All rights reserved.
//

import Foundation

enum HiveErrorDomain: String {
    case urlGeneration = "URLGeneration"
    case noErrorFromServer = "No Error"
    case jsonParsingError = "JSONParsing"
    case noNetwork = "No Network Present"
}

extension NSError {
    class func noNetworkAvailable() -> NSError {
        let errorDomain = HiveErrorDomain.noNetwork.rawValue
        let desc = "The Internet connection appears to be offline"
        let error = NSError(domain: errorDomain,
                            code: (-3),
                            userInfo: [NSLocalizedDescriptionKey: desc])
        return error
    }
    class func urlRequestGenerationError() -> NSError {
        let errorDomain = HiveErrorDomain.urlGeneration.rawValue
        let desc = "url param corrupt"
        let error = NSError(domain: errorDomain,
                            code: (-1),
                            userInfo: [NSLocalizedDescriptionKey: desc])
        return error
    }
    class func noErrorReturned() -> NSError {
        let errorDomain = HiveErrorDomain.noErrorFromServer.rawValue
        let desc = "No error returned From Server"
        let error = NSError(domain: errorDomain,
                            code: (-2),
                            userInfo: [NSLocalizedDescriptionKey: desc])
        return error
    }

    class func parsingError() -> NSError {
        let errorDomain = HiveErrorDomain.jsonParsingError.rawValue
        let desc = "JSON value type mismatch at key path"
        let error = NSError(domain: errorDomain,
                            code: (-3),
                            userInfo: [NSLocalizedDescriptionKey: desc])
        return error
    }

    class func error(returnCode: Int) -> NSError {
        let errorDomain = "Response Error"
        let desc = "Error returned from server"
        let error = NSError(domain: errorDomain,
                            code: returnCode,
                            userInfo: [NSLocalizedDescriptionKey: desc])
        return error
    }
}
