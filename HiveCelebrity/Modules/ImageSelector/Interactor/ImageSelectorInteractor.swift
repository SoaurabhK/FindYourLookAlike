//
//  ImageSelectorImageSelectorInteractor.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

class ImageSelectorInteractor: ImageSelectorInteractorInput {

    weak var output: ImageSelectorInteractorOutput!

    func fetchCelebrityDetailsWithImage(imageData: Data) {
        HiveAPIInterface.sharedInterface.fetchCelebrityDetails(imageData: imageData) { (result: Result<ServerCelebrityResponse>) in
            DispatchQueue.main.async { [weak self] in
                if let celebrityResponse = result.data {
                    self?.output.celebrityInfoFetched(result: celebrityResponse)
                } else {
                    self?.output.errorInFetchingCelebrityInfo(error: result.error)
                }
            }
        }
    }
}
