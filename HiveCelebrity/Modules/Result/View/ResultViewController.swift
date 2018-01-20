//
//  ResultResultViewController.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 26/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit
import Social
import FlexiblePageControl

class ResultViewController: UIViewController {

    var output: ResultViewOutput!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tryiveButton: UIButton!
    @IBOutlet weak var shareOnFBButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var shareButtonsView: UIView!
    @IBOutlet weak var pageControlContainerView: UIView!

    var pageControl: FlexiblePageControl!

    lazy var shareView: ResultShareView = {
        guard let view = Bundle.main.loadNibNamed("ResultShareView", owner: nil, options: nil)?.first as? ResultShareView else  {
            fatalError("result share view should be present")
        }
        return view
    }()

    struct Constants {
        static let collectionViewCellReuseIdentifier = "ResultCollectionViewCell"
        static let collectinViewInterItemSpacing: CGFloat = 24
        static let collectionViewHorizontalContentInset: CGFloat = 38
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    func configureTryHiveButtonText() {
        let attributedString = NSAttributedString(string: "Try Hive Enterprise",
                                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                               NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .regular),
                                                               NSAttributedStringKey.underlineColor: UIColor.white,
                                                               NSAttributedStringKey.underlineStyle: 1])
        self.tryiveButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    func configureCollectionView() {
        self.collectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.collectionViewCellReuseIdentifier)
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        let layout = CenterPageLayout()

        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: Constants.collectionViewHorizontalContentInset,
                                           bottom: 0,
                                           right: Constants.collectionViewHorizontalContentInset)
        layout.minimumInteritemSpacing = Constants.collectinViewInterItemSpacing
        self.collectionView.collectionViewLayout = layout
        
    }
    
    func configurePageControl() {
        self.pageControl = FlexiblePageControl()
        self.pageControl.frame = self.pageControlContainerView.bounds
        self.pageControlContainerView.addSubview(self.pageControl)
        self.pageControl.numberOfPages = self.output.numberOfCelebData
        self.pageControl.updateViewSize()

        self.pageControl.dotSize = 7
        self.pageControl.dotSpace = 4

        self.pageControl.displayCount = min(12 , self.pageControl.numberOfPages)
        self.pageControl.smallDotSizeRatio = 0.5
        self.pageControl.mediumDotSizeRatio = 0.8

        self.pageControl.pageIndicatorTintColor = Color.appTextTertiaryBlue
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
    }
    
    func getShareImage() -> UIImage? {
        self.view.addSubview(self.shareView)
        self.shareView.setHeight()
        
        UIGraphicsBeginImageContextWithOptions(self.shareView.bounds.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        self.shareView.layer.render(in: context!)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.shareView.removeFromSuperview()
        return snapshot
    }
    
    //IBActions
    @IBAction func retakeTapped(_ sender: Any) {
        self.output.retakeTapped()
    }
    @IBAction func originalTapped(_ sender: Any) {
        self.output.showOriginalPhoto()
    }
    @IBAction func tryHiveTapped(_ sender: Any) {
        self.output.tryHiveTapped()
    }
    @IBAction func shareOnFBTapped(_ sender: Any) {
        self.output.shareOnFBTapped()
    }
    @IBAction func shareResultsTapped(_ sender: Any) {
        self.output.shareResultsTapped()
    }
    @IBAction func tryAgainTapped(_ sender: Any) {
        self.output.retakeTapped()
    }
}

private extension ResultViewController {
    var canShareOnFB: Bool {
        return UIApplication.shared.canOpenURL(URL(string: "fb://")!)
    }

    func shareImageOnFb(image: UIImage) {
        if (self.canShareOnFB) {
            let postController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
            postController.add(image)
            self.present(postController, animated: true, completion: nil)
        } else {
            DLOG("Fb app not installed")
        }
    }

    func shareImageViaShareSheet(image: UIImage){
        let shareItems = [image]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.postToFacebook]
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = self.view.convert(self.shareButton.frame, from: self.shareButtonsView)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }

    func updateViewForCenteredCell() {
        let pointInCV = self.view.convert(self.collectionView.center, to: self.collectionView)
        if let foccusedCellIndexPath = self.collectionView.indexPathForItem(at: pointInCV) {
            self.pageControl.currentPage = foccusedCellIndexPath.row
        }
    }
}

extension ResultViewController: ResultViewInput {
    // MARK: ResultViewInput
    func setupInitialState() {
        self.configureTryHiveButtonText()
        self.configureCollectionView()
        self.configurePageControl()
        self.updateViewForCenteredCell()
        self.shareOnFBButton.isHidden = !self.canShareOnFB
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        self.shareView.dataModel = self.output.resultDataModel
    }

    func configureForSinglePage() {
        self.pageControl.isHidden = true
        self.collectionView.isScrollEnabled = false
    }
    
    func shareImageToFb(imageData: Data) {
        if let shareImage = self.getShareImage() {
            self.shareImageOnFb(image: shareImage)
        } else if let image = UIImage(data: imageData, scale: Constant.imageCompressionPercentage) {
            self.shareImageOnFb(image: image)
        }
    }
    func shareResults(imageData: Data) {
        if let shareImage = self.getShareImage() {
            self.shareImageViaShareSheet(image: shareImage)
        } else if let image = UIImage(data: imageData, scale: Constant.imageCompressionPercentage) {
            self.shareImageViaShareSheet(image: image)
        }
    }
    func showShareButtons(show: Bool) {
        self.shareButtonsView.isHidden = !show
        self.tryAgainButton.isHidden = show
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.output.numberOfCelebData
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellReuseIdentifier, for: indexPath) as? ResultCollectionViewCell else { return UICollectionViewCell() }
        let celebData = self.output.dataForItemAtIndex(index: indexPath.row)
        cell.configureWithCelebData(data: celebData)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateViewForCenteredCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        updateViewForCenteredCell()
    }
}

extension ResultViewController: ResultRouterOutput {
    func push(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func present(viewController: UIViewController, completion: (()->Void)? = nil) {
        self.navigationController?.present(viewController, animated: true, completion: completion)
    }
}

extension ResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width - (2 * Constants.collectionViewHorizontalContentInset),
                                 height: self.collectionView.bounds.height)
    }

}
