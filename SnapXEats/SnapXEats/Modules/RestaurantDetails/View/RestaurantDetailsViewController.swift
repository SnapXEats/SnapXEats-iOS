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
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantAddressLabel: UILabel!
    
    var presenter: RestaurantDetailsPresentation?
    var restaurant: Restaurant!
    var slideshow =  ImageSlideshow()
    var specialities = [RestaurantSpeciality]()
    var restaurantDetails: RestaurantDetails?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        slideshow.frame = slideshowContainer.frame
        slideshowContainer.addSubview(slideshow)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRestaurantDetails()
    }
    
    override func success(result: Any?) {
        hideLoading()
        if let result = result as? RestaurantDetailsItem {
            restaurantDetails = result.restaurantDetails
            showRestaurantDetails()
        }
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        if let phoneNumberStr = restaurantDetails?.contactNumber {
            // String maipulation to convert number is iPhone Specific format
            let phnone = phoneNumberStr.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
            if let url = URL(string: "tel://\(phnone)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func directionButtonAction(_ sender: UIButton) {
        
    }
    
    private func getRestaurantDetails() {
        showLoading()
        presenter?.restaurantDetailsRequest(restaurantId: restaurant.restaurant_info_id!)
    }
    
    private func showRestaurantDetails() {
        if let details = restaurantDetails {
            restaurantNameLabel.text = details.name ?? SnapXEatsAppDefaults.emptyString
            restaurantAddressLabel.text = details.address ?? SnapXEatsAppDefaults.emptyString
            specialities = details.specialities
            specialityCollectionView.reloadData()
            setupImageSlideshowWithPhotos(photos: details.photos)
        }
    }
}

extension RestaurantDetailsViewController: RestaurantDetailsView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.restaurantDetail, isDetailPage: true)
        registerCellForNib()
    }
    
    private func registerCellForNib() {
        let nib = UINib(nibName: SnapXEatsNibNames.restaurantSpecialityCollectionViewCell, bundle: nil)
        specialityCollectionView.register(nib, forCellWithReuseIdentifier: SnapXEatsCellResourceIdentifiler.restaurantSpeciality)
    }
    
    func setupImageSlideshowWithPhotos(photos: [RestaurantPhoto]) {
        
        var inputsources = [AlamofireSource]()
        for photo in photos {
            if let photoURLString = photo.imageURL, let source = AlamofireSource(urlString: photoURLString) {
               inputsources.append(source)
            }
        }
        
        slideshow.setImageInputs(inputsources)
        slideshow.contentScaleMode = .scaleAspectFit
        slideshow.slideshowInterval = 0
        slideshow.pageControlPosition = .hidden
        slideshow.activityIndicator = DefaultActivityIndicator(style: .whiteLarge, color: .black)
        self.slideshowCountLabel.text = "1/\(inputsources.count)"
        slideshow.currentPageChanged = { (index) in
            self.slideshowCountLabel.text = "\(index+1)/\(inputsources.count)"
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
        cell.configureSpecialityCell(specialityItem: specialities[indexPath.row])
        return cell
    }
}

