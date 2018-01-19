//
//  CuisineCollectionViewCell.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 19/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class CuisineCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellContainerView.addShadow()
    }
}
