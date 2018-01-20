//
//  ImagePreviewImagePreviewViewController.swift
//  hive-celebrity-ios
//
//  Created by cd /Users/Soaurabh/WORK/Xcode/HiveCelebrity/Templates on 28/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    var output: ImagePreviewViewOutput!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

// MARK: ImagePreviewViewInput
extension ImagePreviewViewController: ImagePreviewViewInput {
    func setupInitialState() {
        self.navigationController?.makeNavigationBarTransparent()
    }

    func updateImageWithData(data: Data) {
        self.imageView.image = UIImage(data: data)
    }
}

// MARK: UIScrollViewDelegate
extension ImagePreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
