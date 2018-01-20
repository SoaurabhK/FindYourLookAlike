//
//  ResultsDataModel.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 29/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation

class ResultsDataModel {
    var imageData: Data!
    var celebritiesInfo: [CelebrityInfo]

    var celebrityPresent: Bool = true

    init(originalImageData imageData: Data, celebritiesInfo: [CelebrityInfo]) {
        self.imageData = imageData
        self.celebritiesInfo = celebritiesInfo
    }
}

struct CelebrityInfo {
    var celebrityName: String?
    var celebrityImageURL: String?
    var localImage: Data?
    var boundingRect: CGRect?
    
}
