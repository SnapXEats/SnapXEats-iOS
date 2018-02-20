//
//  RestaurantDetailsViewController.swift
//  
//
//  Created by Durgesh Trivedi on 19/02/18.
//  
//

import Foundation
import UIKit

class RestaurantDetailsViewController: BaseViewController, StoryboardLoadable {

    
    @IBOutlet var slideshowContainer: UIView!
    @IBOutlet var slideshowCountLabel: UILabel!
    @IBOutlet var specialityCollectionView: UICollectionView!
    
    var presenter: RestaurantDetailsPresentation?
    var restaurant: Restaurant!
    var slideshow =  ImageSlideshow()
    var specialities = ["https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080", "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080", "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        slideshow.frame = slideshowContainer.frame
        slideshowContainer.addSubview(slideshow)
    }
}

extension RestaurantDetailsViewController: RestaurantDetailsView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.restaurantDetail, isDetailPage: true)
        registerCellForNib()
        setupImageSlideshow()
    }
    
    private func registerCellForNib() {
        let nib = UINib(nibName: SnapXEatsNibNames.restaurantSpecialityCollectionViewCell, bundle: nil)
        specialityCollectionView.register(nib, forCellWithReuseIdentifier: SnapXEatsCellResourceIdentifiler.restaurantSpeciality)
    }
    
    func setupImageSlideshow() {
        let alamofireSource = [AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
        
        slideshow.setImageInputs(alamofireSource)
        slideshow.contentScaleMode = .scaleAspectFill
        slideshow.slideshowInterval = 0
        slideshow.pageControlPosition = .hidden
        slideshow.activityIndicator = DefaultActivityIndicator(style: .whiteLarge, color: .black)
        self.slideshowCountLabel.text = "1/\(alamofireSource.count)"
        slideshow.currentPageChanged = { (index) in
            self.slideshowCountLabel.text = "\(index+1)/\(alamofireSource.count)"
        }
    }
}

extension RestaurantDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return specialities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnapXEatsCellResourceIdentifiler.restaurantSpeciality, for: indexPath) as! RestaurantSpecialityCollectionViewCell
        if let imageURL = URL(string: specialities[indexPath.row]) {
            cell.specialityImageView.af_setImage(withURL: imageURL, placeholderImage:UIImage(named: SnapXEatsImageNames.placeholder_cuisine)!)
        }
        return cell
    }
}

