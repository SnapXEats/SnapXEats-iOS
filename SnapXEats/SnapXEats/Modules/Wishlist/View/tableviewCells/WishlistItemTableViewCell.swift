//
//  WishlistItemTableViewCell.swift
//  SnapXEats
//
//  Created by synerzip on 02/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit


class WishlistItemTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var wishlistItemImageView: UIImageView!
    @IBOutlet var wishlistItemName: UILabel!
    @IBOutlet var wishlistItemCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setWishListItem(item: WishListItem, isSelected: Bool) {
        wishlistItemName.text = item.restaurant_name
        wishlistItemCity.text = item.restaurant_address + "   |   " + formatDateFromString(datestr: item.created_at)
        let placeholderImage = UIImage(named: SnapXEatsImageNames.wishlist_placeholder)!
        if (item.dish_image_url != "") {
            let url = URL(string: item.dish_image_url)!
            wishlistItemImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            wishlistItemImageView.image = placeholderImage
        }
        
        let shadowColor = isSelected ? UIColor.red : UIColor.rgba(202.0, 202.0, 202.0, 1)
        containerView.fullShadow(color: shadowColor, offSet: CGSize(width: 0, height: 0))
    }
}
