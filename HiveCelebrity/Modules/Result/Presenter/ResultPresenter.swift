//
//  ResultResultPresenter.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 26/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

class ResultPresenter: ResultModuleInput, ResultInteractorOutput {

    weak var view: ResultViewInput!
    var interactor: ResultInteractorInput!
    var router: ResultRouterInput!
    var dataModel: ResultsDataModel!

    func imageDataToShare() -> Data {
        // need to send the actual image later
        return self.dataModel.imageData
    }
}

extension ResultPresenter: ResultViewOutput {
    
    var resultDataModel: ResultsDataModel {
        return self.dataModel
    }

    func dataForItemAtIndex(index: Int) -> CelebrityInfo {
        let celebData = self.dataModel.celebritiesInfo[index]
        return celebData
    }

    var numberOfCelebData: Int {
        get {
            return self.dataModel.celebritiesInfo.count
        }
        set {
            // do nothing
        }
    }

    func viewIsReady() {
        self.view.setupInitialState()
        if self.numberOfCelebData <= 1 {
            self.view.configureForSinglePage()
        }
        self.view.showShareButtons(show: self.dataModel.celebrityPresent)
    }
    
    func retakeTapped() {
        self.router.takeBackToPreviousScreen()
    }
    
    func showOriginalPhoto() {
        self.router.showOriginalImageModule(imageData: self.dataModel.imageData)
    }
    
    func shareOnFBTapped() {
        self.view.shareImageToFb(imageData: self.imageDataToShare())
    }
    
    func shareResultsTapped() {
        self.view.shareResults(imageData: self.imageDataToShare())
    }
    
    func tryHiveTapped() {
        self.router.showHiveEnterpriseModule()
    }
}
