//
//  ImageSelectorImageSelectorViewOutput.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import Foundation

protocol ImageSelectorViewOutput {

    /**
        @author Soaurabh Kakkar
        Notify presenter that view is ready
    */

    func viewIsReady()
    func cameraIsReady()
    func cameraPermissionDenied()
    func enabledCameraAccessTapped()
    func enabledGalleryAccessTapped()
    func flipCameraTapped()
    func captureImageTapped()
    func imageCaptured(withData: Data?, originMode: PhotoOriginMode)
    func retakeTapped()
    func galleryTapped()
    func toggleFlashTapped()
    func usePhotoTapped()
    func resetView()
}
