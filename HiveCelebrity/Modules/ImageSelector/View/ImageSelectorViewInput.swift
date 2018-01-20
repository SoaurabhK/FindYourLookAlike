//
//  ImageSelectorImageSelectorViewInput.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import Foundation
import AVFoundation

protocol ImageSelectorViewInput: class {

    /**
        @author Soaurabh Kakkar
        Setup initial state of the view
    */
    func confirmCameraPermissionAndConfigureView()
    func setupInitialState()
    func setupCameraView()
    func showCameraPermissionDeniedView()
    func resetCurrentCaptureSession()
    func setupNewCaptureSession(forCameraSide: CameraSide)
    func startNewCaptureSession()
    func captureCurrentImage(withFlashState: AVCaptureDevice.FlashMode)
    func setImage(withData data: Data, photoOrigin: PhotoOriginMode)
    func configureView(withImageState: ImageState)
    func openGallery()
    func updateView(withFlashState: AVCaptureDevice.FlashMode)
    func toggleFlashButtonVisiblity(forCameraSide: CameraSide)
    func updateViewForOverlayState(state: OverlayState)
    func toggleOverlayView(show: Bool)
}
