//
//  ResultShareView.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 08/01/18.
//  Copyright © 2018 Soaurabh Kakkar. All rights reserved.
//

import UIKit

class ResultShareView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var originalImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var originalImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var multipleMatchView: UIView!
    @IBOutlet weak var singleMatchView: UIView!
    @IBOutlet weak var singleMatchLabel: UILabel!
    @IBOutlet weak var singleMatchOriginalImageView: UIImageView!
    @IBOutlet weak var singleMatchCelebrityImageView: UIImageView!

    let path = UIBezierPath()
    
    struct Constants {
        static let cellAspectRatio: CGFloat = 1.7//height/width
        static let cellReuseIdentifier = "ResultShareViewCollectionViewCell"
        static let numberOfCellsPerRow: CGFloat = 5
        static let interItemSpacing: CGFloat = 6
        static let horizontalPadding: CGFloat = 10
        static let collectionViewBottomPadding: CGFloat = 41.0
    }

    struct NumberViewConstants {
        static let minimumFontSize: CGFloat = 8.0
        static let maximumFontSize: CGFloat = 20.0
        static let maximumLabelSide: CGFloat = 25.0
        static let minimumLabelSide: CGFloat = 12.0
        static let widthRatio: CGFloat = 0.35
    }
    
    var dataModel: ResultsDataModel? {
        didSet {
            DispatchQueue.main.async {
                self.configureView()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.addBoundingBoxes()
    }
    
    func configureView() {
        configureCollectionView()
        
        guard let model = self.dataModel else { return }
        if model.celebritiesInfo.count == 1 {
            configureViewForSingleMatch(forModel: model)
        } else {
            configureViewForMultipleMatches(forModel: model)
        }
    }
    
    func configureViewForSingleMatch(forModel model: ResultsDataModel) {
        self.multipleMatchView.isHidden = true
        self.singleMatchView.isHidden = false
        
        guard let originalImage = UIImage(data: model.imageData), let celebInfo = model.celebritiesInfo.first else { return }
        self.singleMatchOriginalImageView.image = originalImage
        
        if let imageURLString = celebInfo.celebrityImageURL, let celebName = celebInfo.celebrityName {
            self.singleMatchCelebrityImageView.sd_setHighlightedImage(with: URL(string: imageURLString), options: []) { [weak self] (image, _, _, _) in
                if let celebImage = image {
                    self?.singleMatchCelebrityImageView.image = celebImage
                    self?.singleMatchCelebrityImageView.contentMode = .scaleAspectFit
                    self?.singleMatchCelebrityImageView.backgroundColor = UIColor.black
                }
            }
            
            self.singleMatchLabel.text = "Your best match is \(celebName)"
        } else {
            self.singleMatchCelebrityImageView.image = UIImage(named: "star")
            self.singleMatchCelebrityImageView.contentMode = .scaleAspectFit
            self.singleMatchLabel.text = "No Match. You are STAR!"
        }
    }
    
    func configureViewForMultipleMatches(forModel model: ResultsDataModel) {
        self.multipleMatchView.isHidden = false
        self.singleMatchView.isHidden = true
        
        configureOriginalImageView(forModel: model)
        self.collectionView.performBatchUpdates(nil) { (completed) in
            if completed {
                self.collectionView.frame.size.height = self.collectionView.contentSize.height
                self.layoutIfNeeded()
            }
        }
    }
    
    func setHeight() {
        guard let model = self.dataModel else { return }
        if model.celebritiesInfo.count == 1 {
            self.frame.size.height = 650.0
        } else {
            self.frame.size.height = self.multipleMatchView.frame.minY + self.collectionView.frame.minY + self.collectionView.contentSize.height + Constants.collectionViewBottomPadding
        }
    }
    
    func addBoundingBoxes() {
        guard let model = self.dataModel, let imageData = self.dataModel?.imageData,
            let originalImage = UIImage(data: imageData) else { return }
        
        let widthFactor: CGFloat = self.originalImageView.frame.size.width/originalImage.size.width
        let heightFactor: CGFloat = self.originalImageView.frame.size.height/originalImage.size.height

        for (index, info) in model.celebritiesInfo.enumerated() {
            guard let rect = info.boundingRect else { continue }
            var actualRect = rect
            actualRect.origin.x = actualRect.origin.x*widthFactor
            actualRect.size.width = actualRect.size.width*widthFactor
            actualRect.origin.y = actualRect.origin.y*heightFactor
            actualRect.size.height = actualRect.size.height*heightFactor

            let rectView = UIView(frame: actualRect)
            rectView.layer.borderColor = UIColor.white.cgColor
            rectView.layer.borderWidth = 1

            let labelSide = min(NumberViewConstants.maximumLabelSide , max((actualRect.size.width * NumberViewConstants.widthRatio), NumberViewConstants.minimumLabelSide))
            let fontSize = min(NumberViewConstants.maximumFontSize, max(labelSide - 4, NumberViewConstants.minimumFontSize))
            let originX = rectView.frame.size.width - labelSide
            let originY = rectView.frame.size.height - labelSide

            let label = UILabel.init(frame: CGRect(x: originX, y: originY, width: labelSide, height: labelSide))
            label.textAlignment = .center
            label.textColor = Color.darkGreyBlue
            label.backgroundColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
            label.text = "\(index+1)"
            rectView.addSubview(label)

            self.originalImageView.addSubview(rectView)
            rectView.frame = actualRect
        }
    }
    
    func configureOriginalImageView(forModel model: ResultsDataModel) {
        guard let image = UIImage(data: model.imageData) else { return }
        self.originalImageView.image = image
        let realImageSize = CGSize(width: image.size.width/UIScreen.main.scale, height: image.size.height/UIScreen.main.scale)
        
        let maxWidth = min(self.bounds.size.width, realImageSize.width)
        self.originalImageViewWidthConstraint.constant = maxWidth
        self.originalImageViewHeightConstraint.constant = min((realImageSize.height*maxWidth)/realImageSize.width, realImageSize.height)
        
    }
    
    func configureCollectionView() {
        self.collectionView.register(UINib(nibName: Constants.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellReuseIdentifier)
    }
}


extension ResultShareView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataModel?.celebritiesInfo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath) as? ResultShareViewCollectionViewCell,
            let celebInfo = self.dataModel?.celebritiesInfo[indexPath.row] else { return UICollectionViewCell() }
        cell.configureWithCelebData(data: celebInfo, forIndex: (indexPath.row + 1))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.size.width
        let emptySpace = Constants.interItemSpacing * (Constants.numberOfCellsPerRow - 1) + (Constants.horizontalPadding * 2)
        let availableSpace = collectionViewWidth - emptySpace
        let cellWidth = availableSpace/Constants.numberOfCellsPerRow
        let cellHeight = Constants.cellAspectRatio * cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
