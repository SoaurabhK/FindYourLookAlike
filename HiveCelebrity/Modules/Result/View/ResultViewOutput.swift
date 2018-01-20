//
//  ResultResultViewOutput.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 26/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

protocol ResultViewOutput {

    /**
        @author Soaurabh Kakkar
        Notify presenter that view is ready
    */

    func viewIsReady()
    func retakeTapped()
    func showOriginalPhoto()
    func shareOnFBTapped()
    func shareResultsTapped()
    func tryHiveTapped()

    func dataForItemAtIndex(index: Int) -> CelebrityInfo
    var numberOfCelebData: Int {
         get set
    }
    var resultDataModel: ResultsDataModel { get }

}
