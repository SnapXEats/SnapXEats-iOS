//
//  RecentFoodJourneyTableViewCell.swift
//  SnapXEats
//
//  Created by Priyanka Gaikwad on 16/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

protocol RecentFoodJourneyCellDelegate: class {
    func updateRecentFoodJourneyCellHeight(indexPath:IndexPath, estimatedHeight:CGFloat)
}

class RecentFoodJourneyTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var foodJourneyItemDate: UILabel!
    @IBOutlet weak var foodJourneyItemName: UILabel!
    @IBOutlet weak var foodJourneyItemLocation: UILabel!
    @IBOutlet weak var foodJourneyItemImageView: UIImageView!
    @IBOutlet weak var foodJourneyItemPoints: UILabel!
    @IBOutlet weak var foodJourneyItemImagesCollectionView: UICollectionView!
    
    @IBOutlet weak var foodJourneyImageBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    // Mark: Properties
    var rewardDishesUrls = [String]()
    var delegate: RecentFoodJourneyCellDelegate?
    
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
    
    func configureRecentFoodJourneyCell(indexPath:IndexPath, item: UserCurrentWeekHistory){
        foodJourneyItemDate.text = item.formattedDate
        foodJourneyItemName.text = item.restaurant_name
        foodJourneyItemLocation.text = item.restaurant_address
        foodJourneyItemPoints.text = "\(item.reward_point)"
        if (item.restaurant_image_url != "") {
            if let url = URL(string: item.restaurant_image_url) {
                foodJourneyItemImageView.af_setImage(withURL: url, placeholderImage: nil)
            }
        }
        
        if item.reward_dishes.count > 0 {
            rewardDishesUrls = item.reward_dishes
            foodJourneyItemImagesCollectionView.isHidden = false
            foodJourneyItemImagesCollectionView.reloadData()
        } else {
            foodJourneyItemImagesCollectionView.isHidden = true
            delegate?.updateRecentFoodJourneyCellHeight(indexPath: indexPath, estimatedHeight: 102)
        }
        
        foodJourneyImageBottomSpace.constant = foodJourneyItemImagesCollectionView.isHidden ? 14 : 90

        let shadowColor = isSelected ? UIColor.red : UIColor.rgba(202.0, 202.0, 202.0, 1)
        containerView.fullShadow(color: shadowColor, offSet: CGSize(width: 0, height: 0))
    }
    
}

extension RecentFoodJourneyTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rewardDishesUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = foodJourneyItemImagesCollectionView.dequeueReusableCell(withReuseIdentifier: SnapXEatsCellResourceIdentifiler.recentFoodJourneyPicturesCollectionView, for: indexPath) as! RecentFoodJourneyPicturesCollectionViewCell
        cell.configurePicturesCell(imageUrl: rewardDishesUrls[indexPath.row])
        return cell
    }
    
    
    
}
