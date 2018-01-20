//
//  AVCaptureManager.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 21/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import AVFoundation

class AVCaptureManager {
    static var isVideoDisabled: Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return status == .restricted || status == .denied
    }
    
    static var videoPermissionStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    }
    
    static func requestVideoPermission(completionBlock: @escaping ((Bool) -> Void)) {
        switch self.videoPermissionStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: completionBlock)
        case .restricted, .denied:
            completionBlock(false)
        case .authorized:
            completionBlock(true)
        }
    }
}
