//
//  RestaurantListTableViewCell.swift
//  SnapXEats
//
//  Created by synerzip on 28/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class RestaurantListTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantLogoImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        restaurantLogoImageView.layer.masksToBounds = true
        restaurantLogoImageView.layer.cornerRadius = restaurantLogoImageView.frame.height/2
        
        // Show selection color for Cell as per specsheet
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.rgba(255.0, 237.0, 220.0, 1.0)
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    func configureRestaurantCell(restaurant: Restaurant) {
        restaurantNameLabel.text = restaurant.restaurant_name ?? ""
        restaurantTypeLabel.text = restaurant.type ?? ""
        if let url = URL(string: restaurant.logoImage ?? "") {
            let placeholderImage = UIImage(named: SnapXEatsImageNames.restaurant_logo)!
            restaurantLogoImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
    }
}
