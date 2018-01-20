//
//  Constant.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 21/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import CoreGraphics

struct Constant {
    static let imageUploadSize = CGSize(width: 1080, height: 1080)
    static let imageCompressionPercentage: CGFloat = 0.6
}

struct APIConstants {
    static let baseURLString = "https://api.thehive.ai/api/v1/tag/task"
    static let timeOutInterval = 60.0
    static let authorizationToken = "Bu7aLrq005YVyu9DqLO1PX2rbUWx09s5"
    static let imageFetchURLPrefix = "https://api-celeb-finder.thehive.ai/name/url?name="
}

struct FeedbackAPIConstants {
    static let baseURLString = "https://api-celeb-finder.thehive.ai/send_feedback"
    static let timeOutInterval = 60.0
}


struct Images {
    static let largePlaceholder = UIImage(named: "largePlaceholder")
    static let smallPlaceholder = UIImage(named: "smallPlaceholder")
}

struct WebLinks {
    static let termsAndConditions = "https://thehive.ai/terms-of-use"
    static let privacyPolicy = "https://thehive.ai/privacy"
}
