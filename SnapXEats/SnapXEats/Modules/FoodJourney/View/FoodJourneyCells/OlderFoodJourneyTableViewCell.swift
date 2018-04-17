//
//  OlderFoodJourneyTableViewCell.swift
//  SnapXEats
//
//  Created by Priyanka Gaikwad on 17/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class OlderFoodJourneyTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var olderFoodJourneyItemName: UILabel!
    @IBOutlet weak var olderFoodJurneyItemLocation: UILabel!
    @IBOutlet weak var olderFoodJourneyItemImageView: UIImageView!
    @IBOutlet weak var olderFoodJourneyItemPoints: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureOlderFoodJourneyCell() {
        let shadowColor = isSelected ? UIColor.red : UIColor.rgba(202.0, 202.0, 202.0, 1)
        containerView.fullShadow(color: shadowColor, offSet: CGSize(width: 0, height: 0))
    }
}
