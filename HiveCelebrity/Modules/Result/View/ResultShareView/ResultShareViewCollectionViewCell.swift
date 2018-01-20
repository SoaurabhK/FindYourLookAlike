//
//  ResultShareViewCollectionViewCell.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 08/01/18.
//  Copyright © 2018 Soaurabh Kakkar. All rights reserved.
//

import UIKit

class ResultShareViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var celebImageView: UIImageView!
    @IBOutlet weak var celebNameLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.numberLabel.textColor = Color.darkGreyBlue
    }
    override func prepareForReuse() {
        self.celebImageView.image = UIImage(named: "star")
        self.celebImageView.contentMode = .scaleAspectFit
        self.celebImageView.backgroundColor = Color.duckEggBlue
    }
    
    func configureWithCelebData(data: CelebrityInfo, forIndex index: Int) {
        self.celebImageView.image = UIImage(named: "star")
        self.celebImageView.contentMode = .scaleAspectFit
        self.celebImageView.backgroundColor = Color.duckEggBlue
        self.numberLabel.text = "\(index)"

        self.celebNameLabel.text = data.celebrityName ?? "No Match \nYou are STAR"
        if let imageURLString = data.celebrityImageURL, let imageURL = URL(string: imageURLString) {
            self.celebImageView.sd_setImage(with: imageURL, completed: {[weak self] (image, error, _, _) in
                if let resultImage = image {
                    self?.celebImageView.image = resultImage
                    self?.celebImageView.contentMode = .scaleAspectFit
                    self?.celebImageView.backgroundColor = UIColor.black
                }
            })
        }
    }

}
