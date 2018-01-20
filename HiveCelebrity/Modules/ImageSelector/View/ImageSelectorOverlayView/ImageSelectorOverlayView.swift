//
//  ImageSelectorOverlayView.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 28/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import Foundation
import UIKit

protocol ImageSelectorOverlayViewDelegate: class {
    func overlayViewClickAgainTapped(overlayView: ImageSelectorOverlayView)
    func overlayViewRetryTapped(overlayView: ImageSelectorOverlayView)
    func overlayViewCloseTapped(overlayView: ImageSelectorOverlayView)
}

class ImageSelectorOverlayView: NibDesignable {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var bottomInfoLabel: UILabel!
    @IBOutlet weak var retryButtonHeightConstraint: NSLayoutConstraint!

    var appBecomeActiveNotificationObserver: NSObjectProtocol?
    var appResignActiveNotificationObserver: NSObjectProtocol?
    var currentState: OverlayState = .noFacesDetected

    weak var delegate: ImageSelectorOverlayViewDelegate?

    private lazy var rotateAnimation: CABasicAnimation = {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = 1.0
        rotateAnimation.repeatCount = Float.greatestFiniteMagnitude
        return rotateAnimation
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateForState(state: self.currentState)
    }

    deinit {
        self.removeNotificationObservers()
    }

    // MARK: IBActions
    @IBAction func retryButtonTapped(_ sender: Any) {
        switch self.currentState {
        case .noInternet, .networkError:
            self.delegate?.overlayViewRetryTapped(overlayView: self)
        case .noFacesDetected:
            self.delegate?.overlayViewClickAgainTapped(overlayView: self)
        case .loaderVisible :
            return // idealy button won;t be visible in this state
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.delegate?.overlayViewCloseTapped(overlayView: self)
    }
    
    func updateForState(state: OverlayState) {
        self.currentState = state
        self.bottomInfoLabel.text = state.infoText
        self.iconImageView.image = UIImage(named: state.iconImageName)
        self.retryButton.setTitle(state.buttonTitle, for: .normal)
        if state == .loaderVisible {
            addAppStateObservers()
            addLoaderAnimations()
            self.retryButtonHeightConstraint.constant = 0.0
            self.retryButton.isHidden = true
            self.closeButton.isHidden = true
        } else {
            removeLoaderAnimation()
            removeNotificationObservers()
            self.retryButton.isHidden = false
            self.retryButtonHeightConstraint.constant = 40.0
            self.closeButton.isHidden = false
        }
    }
}

private extension ImageSelectorOverlayView  {

    func addAppStateObservers() {
        self.appBecomeActiveNotificationObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive,
                                                                                          object: nil,
                                                                                          queue: nil)
        { [weak self] (notification) in
            self?.addLoaderAnimations()
        }

        self.appResignActiveNotificationObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive,
                                                                                          object: nil,
                                                                                          queue: nil)
        { [weak self] (notification) in
            self?.removeLoaderAnimation()
        }
    }

    func removeNotificationObservers() {
        guard let appResignActiveObserver = self.appResignActiveNotificationObserver,
            let appBecomeActiveObserver = self.appBecomeActiveNotificationObserver else {
                return
        }
        NotificationCenter.default.removeObserver(appResignActiveObserver)
        NotificationCenter.default.removeObserver(appBecomeActiveObserver)
        self.appResignActiveNotificationObserver = nil
        self.appBecomeActiveNotificationObserver = nil
    }

    func removeLoaderAnimation() {
        self.iconImageView.layer.removeAllAnimations()
    }

    func addLoaderAnimations() {
        if self.currentState == .loaderVisible {
            self.iconImageView.layer.add(self.rotateAnimation, forKey: nil)
        }
    }
}
