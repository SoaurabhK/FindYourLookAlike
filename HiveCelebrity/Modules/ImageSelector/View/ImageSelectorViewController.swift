//
//  ImageSelectorImageSelectorViewController.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ImageSelectorViewController: UIViewController {

    enum ViewState {
        case previewImage
        case camera
        case cameraPermissionDenied
    }

    var output: ImageSelectorViewOutput!

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var reverseButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var usePhotoButton: UIButton!
    @IBOutlet weak var toggleFlashButton: UIButton!
    @IBOutlet weak var permissionDeniedView: UIView!

    @IBOutlet weak var overlayView: ImageSelectorOverlayView!

    lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        return session
    }()
    
    lazy var stillImageOutput: AVCapturePhotoOutput = {
        let imageOutput = AVCapturePhotoOutput()
        imageOutput.isHighResolutionCaptureEnabled = true
        return imageOutput
    }()
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer()
        layer.session = self.captureSession
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.connection?.videoOrientation = .portrait
        return layer
    }()
    
    var currentDeviceInput: AVCaptureDeviceInput?
    var flashAllowed = true // will update depending on current camera side selected

    var currentDevice: ((CameraSide) -> (AVCaptureDevice)) = { side in
        switch side {
        case .back:
            return Camera.backCamera
        case .front:
            return Camera.frontCamera
        }
    }
    
    var imageSettings: AVCapturePhotoSettings {
        if #available(iOS 11.0, *) {
            return AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        } else {
            // Fallback on earlier versions
            return AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
        }
    }

    var orientationIsLandscape: Bool {
        return UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.output.viewIsReady()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: IBActions
    
    @IBAction func capturetapped(_ sender: Any) {
        self.output.captureImageTapped()
    }
    
    @IBAction func fliptapped(_ sender: Any) {
        self.output.flipCameraTapped()
    }
    
    @IBAction func gallerytapped(_ sender: Any) {
        self.output.galleryTapped()
    }
    
    @IBAction func retaketapped(_ sender: Any) {
        self.output.retakeTapped()
    }
    
    @IBAction func toggleFlashTapped(_ sender: Any) {
        self.output.toggleFlashTapped()
    }
    
    @IBAction func usePhototapped(_ sender: Any) {
        self.output.usePhotoTapped()
    }
    @IBAction func enableCameraPermissionTapped(_ sender: Any) {
        self.output.enabledCameraAccessTapped()
    }
}

// MARK: Private methods
private extension ImageSelectorViewController {

    func updateViewForState(_ state: ViewState) {
        self.cameraView.isHidden = true
        self.imageView.isHidden = true
        self.permissionDeniedView.isHidden = true

        switch state {
        case .camera:
            self.cameraView.isHidden = false
        case .previewImage:
            self.imageView.isHidden = false
        case .cameraPermissionDenied:
            self.permissionDeniedView.isHidden = false
        }
    }

    func imageDataFromImageAfterResizing(image: UIImage) -> Data? {
        let resizedImage = image.resize(toSize: Constant.imageUploadSize) ?? image
        return UIImageJPEGRepresentation(resizedImage, Constant.imageCompressionPercentage)
    }

    func requestCameraPermissionAndConfigureView() {
        AVCaptureManager.requestVideoPermission { [weak self] (granted) in
            DispatchQueue.main.async {
                if granted {
                    self?.output.cameraIsReady()
                } else {
                    self?.output.cameraPermissionDenied()
                }
            }
        }
    }
    func handlePhotoGalleryForPermission(granted: Bool) {
        if granted {
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.mediaTypes = [kUTTypeImage as String]
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        } else {
            showGalleryDeniedAlert()
        }
    }

    func requestGalleryPermissionAndConfigure() {
        PhotoManager.requestGalleryPermission { [weak self] (status) in
            DispatchQueue.main.async {
                self?.handlePhotoGalleryForPermission(granted: status)
            }
        }
    }

    func showGalleryDeniedAlert () {
        let title = "Please provide access to your photo gallery. To do so, click on Settings below."
        let message = ""
        let cancelAction = ActionInterface(title: "Cancel")
        let settingsAction = ActionInterface(title: "Settings")
        self.showAlert(title: title,
                       message: message,
                       actionInterfaceList: [cancelAction, settingsAction] ,
                       handler: { [weak self] actionInterface in
                        if actionInterface.title == settingsAction.title {
                            self?.output.enabledGalleryAccessTapped()
                        } else {

                        }
        })
    }
}

// MARK: ImageSelectorViewInput
extension ImageSelectorViewController: ImageSelectorViewInput {
    func confirmCameraPermissionAndConfigureView() {
        switch AVCaptureManager.videoPermissionStatus {
        case .authorized:
            self.output.cameraIsReady()
        case .denied, .restricted:
            self.output.cameraPermissionDenied()
        case .notDetermined:
            self.requestCameraPermissionAndConfigureView()
        }
    }

    func setupInitialState() {
        self.permissionDeniedView.isHidden = true
        self.toggleFlashButton.isHidden = false
        self.overlayView.isHidden = true
        self.overlayView.delegate = self
    }

    func showCameraPermissionDeniedView() {
        self.permissionDeniedView.isHidden = false
        self.toggleFlashButton.isHidden = true
        self.reverseButton.isEnabled = false
        self.captureButton.isEnabled = false
        self.updateViewForState(.cameraPermissionDenied)
    }
    
    func setupCameraView() {
        // wait to let frames be set
        DispatchQueue.main.async { [weak self] in
            guard let this = self else {return }
            //add Preview layer to camera view
            this.cameraView.layer.addSublayer(this.previewLayer)
            this.previewLayer.frame = this.cameraView.bounds

            //add output to capture session
            if this.captureSession.canAddOutput(this.stillImageOutput) {
                this.captureSession.addOutput(this.stillImageOutput)
            }
        }
    }
    
    func resetCurrentCaptureSession() {
        guard let currentInput = self.currentDeviceInput else { return }
        DispatchQueue.main.async {
            if self.captureSession.inputs.count > 0 {
                self.captureSession.stopRunning()
                self.captureSession.removeInput(currentInput)
            }
        }
    }
    
    func setupNewCaptureSession(forCameraSide side: CameraSide) {
        guard let newDeviceInput = try? AVCaptureDeviceInput(device: self.currentDevice(side)) else { return }
        DispatchQueue.main.async {
            self.currentDeviceInput = newDeviceInput
            if self.captureSession.canAddInput(newDeviceInput) {
                self.captureSession.addInput(newDeviceInput)
            }
        }
    }
    
    func startNewCaptureSession() {
        DispatchQueue.main.async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }
    
    func captureCurrentImage(withFlashState state: AVCaptureDevice.FlashMode) {
        guard let _ = self.stillImageOutput.connection(with: AVMediaType.video) else {
            //connection not found
            //Although control will never reach here
            return
        }
        let settings = self.imageSettings
        if self.flashAllowed {
            settings.flashMode = state // do not put flash state if control not shown, can happen when flash is not present
        }
        self.stillImageOutput.capturePhoto(with: settings, delegate: self)
    }

    func setImage(withData data: Data, photoOrigin: PhotoOriginMode) {
        self.imageView.image = UIImage(data: data)
        if photoOrigin == .camera  && !orientationIsLandscape {
            self.imageView.contentMode = .scaleAspectFill
        } else {
            self.imageView.contentMode = .scaleAspectFit

        }
        self.updateViewForState(.previewImage)
    }
    
    func configureView(withImageState state: ImageState) {
        self.cameraView.isHidden = state == .captured
        self.captureButton.isHidden = state == .captured
        self.reverseButton.isHidden = state == .captured
        self.galleryButton.isHidden = state == .captured
        self.imageView.isHidden = state == .uncaptured
        self.retakeButton.isHidden = state == .uncaptured
        self.usePhotoButton.isHidden = state == .uncaptured

        if state == .uncaptured {
            if AVCaptureManager.isVideoDisabled {
                self.updateViewForState(.cameraPermissionDenied)
                self.toggleFlashButton.isHidden = true
            } else {
                self.updateViewForState(.camera)
                self.toggleFlashButton.isHidden = !self.flashAllowed
            }
        } else {
            self.toggleFlashButton.isHidden = true
        }
    }
    
    func openGallery() {
        switch (PhotoManager.galleryPermissionStatus) {
        case .denied, .restricted:
            self.handlePhotoGalleryForPermission(granted: false)
        case .authorized:
            self.handlePhotoGalleryForPermission(granted: true)
        case .notDetermined:
            self.requestGalleryPermissionAndConfigure()
        }
    }
    
    func updateView(withFlashState flashState: AVCaptureDevice.FlashMode) {
        let flashStateImage = UIImage(named: flashState.imageName)
        self.toggleFlashButton.setImage(flashStateImage, for: .normal)
        self.toggleFlashButton.setImage(flashStateImage, for: .highlighted)
    }
    
    func toggleFlashButtonVisiblity(forCameraSide side: CameraSide) {
        self.flashAllowed = self.currentDevice(side).hasFlash
        self.toggleFlashButton.isHidden = !self.flashAllowed
    }

    func updateViewForOverlayState(state: OverlayState) {
        self.overlayView.updateForState(state: state)
    }

    func toggleOverlayView(show: Bool) {
        self.overlayView.isHidden = !show
    }
}

extension ImageSelectorViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard let sampleBuffer = photoSampleBuffer,
            let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer),
            let ciImage = CIImage(data: data),
            let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent)  else { return }
        
        let isFrontCamera = self.currentDeviceInput?.device == self.currentDevice(.front)
        var orientation = UIImageOrientation.right

        switch UIDevice.current.orientation {
        case .landscapeLeft:
            orientation = isFrontCamera ? .down : .up
        case .landscapeRight:
            orientation =  isFrontCamera ? .up : .down
        case .portraitUpsideDown:
            orientation = .rightMirrored
        default:
            orientation = isFrontCamera ? .leftMirrored : .right
        }

        let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation)

        let imageData = self.imageDataFromImageAfterResizing(image: image)
        self.output.imageCaptured(withData: imageData, originMode: .camera)
    }
}

extension ImageSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage,
            let imageData = self.imageDataFromImageAfterResizing(image: selectedImage) else {
            //element not of UIImage type
            picker.dismiss(animated: true, completion: nil)
            return
        }
        self.output.imageCaptured(withData: imageData, originMode: .gallery)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ImageSelectorViewController: ImageSelectorRouterOutput {
    
    func push(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ImageSelectorViewController: ImageSelectorOverlayViewDelegate {
    func overlayViewClickAgainTapped(overlayView: ImageSelectorOverlayView) {
        // reset to capture screen
        self.output.resetView()
    }
    func overlayViewRetryTapped(overlayView: ImageSelectorOverlayView) {
        // send api call to server again
        self.output.usePhotoTapped()
    }

    func overlayViewCloseTapped(overlayView: ImageSelectorOverlayView) {
        self.output.resetView()
    }
}
