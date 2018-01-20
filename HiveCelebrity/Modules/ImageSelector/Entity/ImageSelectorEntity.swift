//
//  ImageSelectorEntity.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 28/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

enum OverlayState {
    case noInternet
    case networkError
    case noFacesDetected
    case loaderVisible

    var infoText: String {
        switch self {
        case .noInternet:
            return "No internet connection"
        case .networkError:
            return "Oops! Something went wrong."
        case .noFacesDetected:
            return "No faces were detected!"
        case .loaderVisible :
            return "Calculating Results…"
        }
    }

    var iconImageName: String {
        switch self {
        case .noInternet:
            return "iconsNoWifi"
        case .networkError:
            return "iconsError"
        case .noFacesDetected:
            return "iconsEmptyResults"
        case .loaderVisible :
            return "iconsLoadingSpinner"
        }
    }

    var buttonTitle: String {
        switch self {
        case .noInternet, .networkError, .loaderVisible:
            return "Retry"
        case .noFacesDetected:
            return "Try Again"
        }
    }
}
