//
//  PhotoManager.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 21/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import Photos

class PhotoManager: NSObject {
    static func requestGalleryPermission(completionBlock: @escaping ((Bool) -> Void)) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ _ in PhotoManager.requestGalleryPermission(completionBlock: completionBlock) })
        case .restricted, .denied:
            completionBlock(false)
        case .authorized:
            completionBlock(true)
        }
    }

    static var galleryPermissionStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
}
