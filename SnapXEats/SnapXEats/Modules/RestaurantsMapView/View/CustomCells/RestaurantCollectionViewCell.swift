//
//  RestaurantCollectionViewCell.swift
//  SnapXEats
//
//  Created by synerzip on 07/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import FSPagerView

class RestaurantCollectionViewCell: FSPagerViewCell {

    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var restaurantPriceLabel: UILabel!
    @IBOutlet var restaurantDistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureRestaurantCell(restaurant: Restaurant) {
        restaurantNameLabel.text = restaurant.restaurant_name ?? ""
        if let price = restaurant.price {
            restaurantPriceLabel.text = "\(PricingPreference(rawValue: price)?.displayText() ?? "")"
        }
        
        if let imageURL = URL(string: restaurant.restaurantDishes[0].dish_image_url ?? "") {
            restaurantImageView.af_setImage(withURL: imageURL, placeholderImage:UIImage(named: SnapXEatsImageNames.placeholder_cuisine)!)
        }
    }
}
