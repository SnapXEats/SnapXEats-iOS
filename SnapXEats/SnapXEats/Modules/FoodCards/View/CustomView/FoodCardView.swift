//
//  FoodCardView.swift
//  SnapXEats
//
//  Created by synerzip on 25/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
fileprivate let foodCardRadius: CGFloat = 6.0

class RoundedCornerImageView: UIImageView { // This is to Show only Top Corner Radius to Imageview
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.topLeft, .topRight], radius: foodCardRadius)
    }
}

class FoodCardView: UIView {

    @IBOutlet weak var foodCardImage: RoundedCornerImageView!
    @IBOutlet weak var foodCardName: UILabel!
    
    func setupFoodCardView(_ frame: CGRect, foodCardItem: FoodCard) {
        self.frame = frame
        self.layer.cornerRadius = foodCardRadius
         let placeholderImage = UIImage(named: SnapXEatsImageNames.foodcard_placeholder)!
        if (foodCardItem.imageURL != "") {
            let url = URL(string: foodCardItem.imageURL)!
            foodCardImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            foodCardImage.image = placeholderImage
        }
        foodCardName.text = foodCardItem.name
    }
}
