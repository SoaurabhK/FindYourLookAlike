//
//  FloatingLabelTextField.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 10/01/18.
//  Copyright © 2018 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class FloatingLabelTextField: SkyFloatingLabelTextField {
    
    let maxLinesCount = 2
    
    var lineCount: CGFloat {
        var lineCount = 1
        if let _ = self.errorMessage {
            let textSize = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
            let height = lroundf(Float(self.titleLabel.sizeThatFits(textSize).height)) + 1
            let charSize = lroundf(Float(self.titleLabel.font.lineHeight))
            lineCount = Int(height/charSize)
        }
        return CGFloat(min(maxLinesCount, lineCount))
    }
    
    var textFieldType: FormTextFieldType = .name {
        didSet {
            setTextFieldProperties()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupColors()
        self.titleFormatter = { (text: String) -> String in
            return text
        }
        self.titleLabel.numberOfLines = maxLinesCount
    }
    
    func setTextFieldProperties() {
        self.title = self.textFieldType.title
        self.placeholder = self.textFieldType.placeholder
    }
    
    func setupColors() {
        self.titleColor = Color.textGrey
        self.selectedLineColor = Color.underLineGrey
        self.selectedTitleColor = Color.textGrey
        self.lineColor = Color.underLineGrey
        self.textColor = Color.primaryDark
        self.placeholderColor = Color.textGrey
        
        self.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        self.placeholderFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        self.titleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
    }
    
    func titleHeightActual() -> CGFloat {
        let height = self.titleHeight()
        return height * lineCount
    }
    
    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        var rect = super.titleLabelRectForBounds(bounds, editing: editing)
        if lineCount > 1 {
            let extraLines = lineCount - 1
            rect.origin.y -= self.titleHeight() * extraLines
            rect.size.height += self.titleHeight() * extraLines
        }
        return rect
    }
    
    
    override func editingChanged() {
        DispatchQueue.main.async {
            super.editingChanged()
        }
    }
    
    func toggleError(show: Bool) {
        self.errorMessage = show ? self.textFieldType.errorMessage : nil
    }
}

