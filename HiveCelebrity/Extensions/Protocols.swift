//
//  Protocols.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 22/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import AVFoundation

protocol Iteratable {
    var caseCount: Int { get }
    mutating func nextValue()
}

protocol ImageNamable {
    var imageName: String { get }
}

extension Iteratable where Self: RawRepresentable, Self.RawValue == Int {
    mutating func nextValue() {
        let nextRawValue = (self.rawValue + 1) % self.caseCount
        self = Self(rawValue: nextRawValue) ?? self
    }
}

extension AVCaptureDevice.FlashMode : Iteratable {
    var caseCount: Int {
        return 3
    }
}

extension AVCaptureDevice.FlashMode : ImageNamable {
    var imageName: String {
        switch self {
        case .off:
            return "flashOff"
        case .on:
            return "flashOn"
        case .auto:
            return "flashAuto"
        }
    }
}
