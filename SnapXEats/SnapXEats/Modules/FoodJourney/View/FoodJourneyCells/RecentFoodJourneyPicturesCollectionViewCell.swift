//
//  RecentFoodJourneyPicturesCollectionViewCell.swift
//  SnapXEats
//
//  Created by Priyanka Gaikwad on 17/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class RecentFoodJourneyPicturesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var rewardDishesImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configurePicturesCell(imageUrl:String){
        if (imageUrl != "") {
            if let url = URL(string: imageUrl) {
                rewardDishesImageView.af_setImage(withURL: url, placeholderImage: nil)
            }
        }
    }

}
