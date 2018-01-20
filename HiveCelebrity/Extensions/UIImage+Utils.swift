//
//  UIImage+Utils.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 21/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func resize(toSize targetSize: CGSize) -> UIImage? {
        let initialSize = self.size
        
        let widthFactor = targetSize.width / initialSize.width;
        let heightFactor = targetSize.height / initialSize.height;
        
        let scaleFactor = min(widthFactor, heightFactor)
        
        let scaledWidth  = initialSize.width * scaleFactor;
        let scaledHeight = initialSize.height * scaleFactor;
        let newSize = CGSize.init(width: scaledWidth, height: scaledHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func cropImageWithRect(_ cropRect:CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, self.scale)
        let origin = CGPoint(x: cropRect.origin.x * CGFloat(-1), y: cropRect.origin.y * CGFloat(-1))
        self.draw(at: origin)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return result
    }

    class func extractImageData(fromImageData imageData: Data, cropRect:CGRect) -> Data? {
        if let image = UIImage(data: imageData),
            let resultingImage = image.cropImageWithRect(cropRect) {
            return UIImageJPEGRepresentation(resultingImage, Constant.imageCompressionPercentage)
        }
        return nil
    }
}
