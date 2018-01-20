//
//  ImageSelectorImageSelectorInteractorOutput.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import Foundation

protocol ImageSelectorInteractorOutput: class {
    func errorInFetchingCelebrityInfo(error: Error?)
    func celebrityInfoFetched(result: ServerCelebrityResponse)

}
