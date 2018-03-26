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
    @IBOutlet weak var preferenceItemStatusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellContainerView.addShadow()
    }

    func configurePreferenceItemCell(preferenceItem: PreferenceItem, preferencetype: PreferenceType) {
        let placeholderImage = UIImage(named: SnapXEatsImageNames.preferences_placeholder)!
        if let item = preferenceItem as? FoodItem {
            preferenceItemNameLabel.text = item.name
            if let imagURL = item.imageURL, let url = URL(string: imagURL) {
                preferenceItemImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
        } else if let item = preferenceItem as? CuisineItem {
            preferenceItemNameLabel.text = item.name
            if let imagURL = item.imageURL {
                let url = URL(string: imagURL)!
                preferenceItemImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
        }
        
        // Set Image for item status based on favourite or Liked
        let image = preferenceItem.isFavourite ? UIImage(named:"favourite_icon") : (preferenceItem.isLiked ? UIImage(named:"like_icon"): nil)
        preferenceItemStatusButton.setImage(image, for: .normal)
        
    }
}
