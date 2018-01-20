//
//  SuccessResponse.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 11/01/18.
//  Copyright © 2018 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SuccessResponse: JSONParsing {
    
    static func parseResults(json: Any) -> SuccessResponse {
        return SuccessResponse()
    }
}
