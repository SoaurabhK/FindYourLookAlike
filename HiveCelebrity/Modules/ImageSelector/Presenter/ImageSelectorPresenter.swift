//
//  ImageSelectorImageSelectorPresenter.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import Foundation
import AVFoundation

enum CameraSide {
    case back, front
}

enum ImageState {
    case captured, uncaptured
}

enum PhotoOriginMode {
    case camera, gallery
}

class ImageSelectorPresenter: ImageSelectorModuleInput {

    weak var view: ImageSelectorViewInput!
    var interactor: ImageSelectorInteractorInput!
    var router: ImageSelectorRouterInput!
    
    var currentCameraSide: CameraSide = .back
    var currentImageState: ImageState = .uncaptured
    var imageData: Data? = nil
    var flashState: AVCaptureDevice.FlashMode = .auto

    lazy var frontCameraAvailable: Bool = {
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front)
    }()

    func toggleCamera() {
        if self.frontCameraAvailable {
            self.currentCameraSide = self.currentCameraSide == .front ? .back : .front
        } else {
            // no toggling if front camera is not available
            self.currentCameraSide =  .back
        }
    }
    
    func restartCaptureSession() {
        self.view.resetCurrentCaptureSession()
        self.view.setupNewCaptureSession(forCameraSide: self.currentCameraSide)
        self.view.startNewCaptureSession()
        self.view.toggleFlashButtonVisiblity(forCameraSide: self.currentCameraSide)
    }
    
    func updateViewWithCapturedImage(photoOriginMode originMode: PhotoOriginMode) {
        if let imageData = self.imageData {
            self.view.setImage(withData: imageData,photoOrigin: originMode)
        }
        self.view.configureView(withImageState: self.currentImageState)
    }
    
    func updateViewForChangedFlashState() {
        self.view.updateView(withFlashState: self.flashState)
    }

    func handleCallSucess (result: ServerCelebrityResponse) {
        guard let imageData = self.imageData else {
            return
        }
        let infoWithCeleb = result.celebritiesInfo.filter { (info) -> Bool in
            return info.celebrityName != nil
        }
        let infoWithoutCeleb = result.celebritiesInfo.filter { (info) -> Bool in
            return info.celebrityName == nil
        }

        let celebritiesData = infoWithCeleb + infoWithoutCeleb

        // Check if faces are detected or not
        if result.noFacesDetected {
            self.view.toggleOverlayView(show: true)
            self.view.updateViewForOverlayState(state: .noFacesDetected)
        } else {
            var celebritiesInfo: [CelebrityInfo] = []
            for data in celebritiesData {
                var celebrityInfo = CelebrityInfo()
                celebrityInfo.celebrityName = data.celebrityName
                celebrityInfo.celebrityImageURL = data.imageURL
                celebrityInfo.localImage = self.extractImageDataFromImageData(imageData, withRect: data.boundingRect)
                celebrityInfo.boundingRect = data.boundingRect
                celebritiesInfo.append(celebrityInfo)
            }
            let celebrityPresent = !result.noCelebrityFound
            self.router.showResultModuleWithOriginalImageData(imageData,
                                                              celebritiesInfo: celebritiesInfo,
                                                              celebrityPresent: celebrityPresent)
            self.view.updateViewForOverlayState(state: .noInternet)
            self.resetView()
        }
    }
}

private extension ImageSelectorPresenter {
    func extractImageDataFromImageData(_ imageData: Data, withRect rect: CGRect?) -> Data? {
        guard let rect = rect else {
            return nil
        }
        return UIImage.extractImageData(fromImageData: imageData, cropRect: rect)
    }
}

extension ImageSelectorPresenter: ImageSelectorInteractorOutput {
    func errorInFetchingCelebrityInfo(error: Error?) {
        var state = OverlayState.networkError
        if let error = error, (error as NSError).domain == HiveErrorDomain.noNetwork.rawValue {
            state = OverlayState.noInternet
        }
        self.view.toggleOverlayView(show: true)
        self.view.updateViewForOverlayState(state: state)

    }
    func celebrityInfoFetched(result: ServerCelebrityResponse) {
        self.handleCallSucess(result: result)
    }
}
extension ImageSelectorPresenter: ImageSelectorViewOutput {
    
    func viewIsReady() {
        if self.frontCameraAvailable {
            self.currentCameraSide = .front
        }
        self.view.setupInitialState()
        self.view.confirmCameraPermissionAndConfigureView()
    }

    func cameraIsReady() {
        self.view.setupCameraView()
        self.restartCaptureSession()
        self.updateViewForChangedFlashState()
    }

    func cameraPermissionDenied() {
        self.view.showCameraPermissionDeniedView()
    }

    func enabledCameraAccessTapped() {
        self.router.moveToAppPhoneSettings()
    }

    func enabledGalleryAccessTapped() {
        self.router.moveToAppPhoneSettings()
    }
    
    func flipCameraTapped() {
        self.toggleCamera()
        self.restartCaptureSession()
    }
    
    func captureImageTapped() {
        self.view.captureCurrentImage(withFlashState: self.flashState)
    }

    func imageCaptured(withData data: Data?, originMode: PhotoOriginMode) {
        guard let imagedData = data else { return }
        self.imageData = imagedData
        self.currentImageState = .captured
        self.updateViewWithCapturedImage(photoOriginMode: originMode)
    }
    
    func retakeTapped() {
        resetView()
    }
    
    func galleryTapped() {
        self.view.openGallery()
    }
    
    func toggleFlashTapped() {
        self.flashState.nextValue()
        self.updateViewForChangedFlashState()
    }
    
    func usePhotoTapped() {
        if let imageData = self.imageData {
            self.view.updateViewForOverlayState(state: .loaderVisible)
            self.view.toggleOverlayView(show: true)
            self.interactor.fetchCelebrityDetailsWithImage(imageData: imageData)
        }
    }
    
    func resetView() {
        self.imageData = nil
        self.currentImageState = .uncaptured
        self.updateViewWithCapturedImage(photoOriginMode: .camera)
        self.view.toggleOverlayView(show: false)
    }
}
