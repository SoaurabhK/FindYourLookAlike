//
//  Camera.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 20/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import AVFoundation

struct Camera {
    static var backCamera: AVCaptureDevice {
        guard let captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                                          for: AVMediaType.video,
                                                          position: AVCaptureDevice.Position.back) else {
            return AVCaptureDevice.default(for: AVMediaType.video)!
        }
        return captureDevice
    }
    
    static var frontCamera: AVCaptureDevice {
        guard let captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                                          for: AVMediaType.video,
                                                          position: AVCaptureDevice.Position.front) else {
            return AVCaptureDevice.default(for: AVMediaType.video)!
        }
        return captureDevice
    }
}
