//
//  ServerCelebrityResponse.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 02/01/18.
//  Copyright © 2018 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ServerCelebrityResponse: JSONParsing {
    var celebritiesInfo: [ServerCelebrityInfo] = []

    static func parseResults(json: Any) -> ServerCelebrityResponse {
        let json = JSON(json)
        if let statusArrayJson = json["status"].array,
            let statusJson = statusArrayJson.first,
            let responseJson = statusJson["response"]["output"].array,
            let outputJson = responseJson.first?.dictionary,
            let celebritiesDataJson = outputJson["bounding_poly"]?.array {
            var celebrityResponse = ServerCelebrityResponse()
            for celebrityJson in celebritiesDataJson {
                let celebrityInfo = ServerCelebrityInfo.init(jsonData: celebrityJson)
                celebrityResponse.celebritiesInfo.append(celebrityInfo)
            }
            return celebrityResponse
        } else {
            // parsing error, return empty response
            return ServerCelebrityResponse()
        }
    }

    var noCelebrityFound: Bool {
        let objectsWithCelebrity = self.celebritiesInfo.filter { (info) -> Bool in
            return info.celebrityPresent
        }
        return objectsWithCelebrity.count == 0
    }

    var noFacesDetected: Bool {
        let objectsWithFaces = self.celebritiesInfo.filter { (info) -> Bool in
            return info.boundingRectFound
        }
        return objectsWithFaces.count == 0
    }
}

struct ServerCelebrityInfo {
    var celebrityName: String?
    var imageURL: String?
    var boundingRect: CGRect?

    var celebrityPresent: Bool {
        return self.celebrityName != nil
    }

    var boundingRectFound: Bool {
        return self.boundingRect != nil
    }

    init(jsonData: JSON) {
        guard let data = jsonData.dictionary else {
            return
        }

        if let classes = data["classes"]?.array,
            let celebrityClass = classes.first,
            let celebrityName = celebrityClass["class"].string {
            self.celebrityName = celebrityName
            // Image url may get change
            self.imageURL = APIConstants.imageFetchURLPrefix + (celebrityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
        }

        if let dimensions = data["dimensions"]?.dictionary,
            let originX =  dimensions["left"]?.int,  let originY = dimensions["top"]?.int,
            let endX =  dimensions["right"]?.int,  let endY = dimensions["bottom"]?.int {
            self.boundingRect = CGRect.init(x: originX, y: originY, width: (endX - originX), height: (endY - originY))
        }
    }
}
