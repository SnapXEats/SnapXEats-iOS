//
//  CuisineCollectionViewCell.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 19/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import AlamofireImage

class CuisineCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellContainerView: UIView!
    
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var cuisineImage: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellContainerView.addShadow()
    }
    
    func configureCell(cuisineItem: Cuisine, isSelected:Bool) {
        cuisineLabel.text = cuisineItem.cuisineName
        if let imagURL = cuisineItem.cuisineImageURL {
        let url = URL(string: imagURL)!
            let placeholderImage = UIImage(named: SnapXEatsImageNames.placeholder_cuisine)!
            cuisineImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        selectedImageView.isHidden = (isSelected) ? false : true
        cellContainerView.alpha = (isSelected) ? 0.2 : 1.0
    }
}
