//
//  ResultCollectionViewCell.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 26/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import UIKit
import SDWebImage

class ResultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var celebNameLabel: UILabel!
    @IBOutlet weak var celebImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var noCelebView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.gradientView.backgroundColor = Color.duckEggBlue
    }

    override func prepareForReuse() {
        self.noCelebView.isHidden = true
        self.celebImageView.image = Images.largePlaceholder
        self.celebImageView.backgroundColor = Color.duckEggBlue
    }

    func configureWithCelebData(data: CelebrityInfo) {
        if let celebrityName = data.celebrityName {
            self.noCelebView.isHidden = true
            self.celebNameLabel.text = celebrityName
        } else {
            self.noCelebView.isHidden = false
        }
        if let localImagData = data.localImage {
            self.userImageView.image = UIImage(data: localImagData)
        }

        self.celebImageView.backgroundColor = Color.duckEggBlue
        if let imageURLString = data.celebrityImageURL,
            let imageURL = URL(string: imageURLString) {
            self.celebImageView.sd_setImage(with: imageURL,
                                            placeholderImage: Images.largePlaceholder,
                                            options: .highPriority,
                                            completed: { [weak self] (image, _, _, _) in
                if image != nil {
                    self?.celebImageView.backgroundColor = UIColor.black
                }
            })
        }
    }
}
