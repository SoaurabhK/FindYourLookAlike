//
//  ImagePreviewImagePreviewPresenter.swift
//  hive-celebrity-ios
//
//  Created by cd /Users/Soaurabh/WORK/Xcode/HiveCelebrity/Templates on 28/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

class ImagePreviewPresenter: ImagePreviewModuleInput, ImagePreviewViewOutput, ImagePreviewInteractorOutput {

    weak var view: ImagePreviewViewInput!
    var interactor: ImagePreviewInteractorInput!
    var router: ImagePreviewRouterInput!
    var dataModel: ImagePreviewDataModel!

    func viewIsReady() {
        self.view.setupInitialState()
        self.view.updateImageWithData(data: self.dataModel.imageData)
    }
}
