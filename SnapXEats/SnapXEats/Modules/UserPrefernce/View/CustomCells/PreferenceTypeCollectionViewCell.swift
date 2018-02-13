//
//  PreferenceTypeCollectionViewCell.swift
//  SnapXEats
//
//  Created by synerzip on 13/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class PreferenceTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var preferenceItemNameLabel: UILabel!
    @IBOutlet weak var preferenceItemImage: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellContainerView.addShadow()
    }

    func configurePreferenceItemCell(preferenceItem: PreferenceItem, preferencetype: PreferenceType, isSelected: Bool) {
        
        if let item = preferenceItem as? FoodItem {
            preferenceItemNameLabel.text = item.foodItemName
            if let imagURL = item.foodItemImageURL, let url = URL(string: imagURL) {
                let placeholderImage = UIImage(named: SnapXEatsImageNames.placeholder_cuisine)!
                preferenceItemImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
        } else if let item = preferenceItem as? Cuisine {
            preferenceItemNameLabel.text = item.cuisineName
            if let imagURL = item.cuisineImageURL {
                let url = URL(string: imagURL)!
                let placeholderImage = UIImage(named: SnapXEatsImageNames.placeholder_cuisine)!
                preferenceItemImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
        }
        selectedImageView.isHidden = (isSelected) ? false : true
        cellContainerView.alpha = (isSelected) ? 0.2 : 1.0
    }
}
