//
//  RestaurantSpecialityCollectionViewCell.swift
//  SnapXEats
//
//  Created by synerzip on 20/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class RestaurantSpecialityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var specialityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureSpecialityCell(specialityItem: RestaurantSpeciality) {
        if let imageURL = URL(string: specialityItem.imageURL ?? "") {
            specialityImageView.af_setImage(withURL: imageURL, placeholderImage:UIImage(named: SnapXEatsImageNames.restaurant_speciality_placeholder)!)
        }
    }
}
