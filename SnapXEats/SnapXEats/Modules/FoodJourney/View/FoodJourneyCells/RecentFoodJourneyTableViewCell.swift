//
//  RecentFoodJourneyTableViewCell.swift
//  SnapXEats
//
//  Created by Priyanka Gaikwad on 16/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class RecentFoodJourneyTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var foodJourneyItemDate: UILabel!
    @IBOutlet weak var foodJourneyItemName: UILabel!
    @IBOutlet weak var foodJourneyItemLocation: UILabel!
    @IBOutlet weak var foodJourneyItemImageView: UIImageView!
    @IBOutlet weak var foodJourneyItemPoints: UILabel!
    @IBOutlet weak var foodJourneyItemImagesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCellForNib()
    }
    
    private func registerCellForNib() {
        let nib = UINib(nibName: SnapXEatsNibNames.recentFoodJourneyPicturesCell, bundle: nil)
        foodJourneyItemImagesCollectionView.register(nib, forCellWithReuseIdentifier: SnapXEatsCellResourceIdentifiler.recentFoodJourneyPicturesCollectionView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureRecentFoodJourneyCell(){
        let shadowColor = isSelected ? UIColor.red : UIColor.rgba(202.0, 202.0, 202.0, 1)
        containerView.fullShadow(color: shadowColor, offSet: CGSize(width: 0, height: 0))
    }
    
}

extension RecentFoodJourneyTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = foodJourneyItemImagesCollectionView.dequeueReusableCell(withReuseIdentifier: SnapXEatsCellResourceIdentifiler.recentFoodJourneyPicturesCollectionView, for: indexPath)
        return cell
    }
    
    
    
}
