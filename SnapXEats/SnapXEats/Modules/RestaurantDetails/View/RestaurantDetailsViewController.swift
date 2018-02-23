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
    @IBOutlet var restaurantTimingButton: UIButton!
    @IBOutlet var restaurantTimingLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    
    private let weekDays = ["Monday": 1, "Tuesday":2, "Wednesday":3, "Thursday":4, "Friday":5, "Saturday":6, "Sunday":7]
    private let durationTrailingText = " Away"
    private enum restaurantTimingConstants {
        static let open = "Open Today"
        static let close = "Closed Now"
    }
    
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
        if let result = result as? RestaurantDetailsItem {
            hideLoading()
            restaurantDetails = result.restaurantDetails
            showRestaurantDetails()
            
            // User should not be blocked for this activity to complete so tSpinner is hidden before this API Call
            self.getDrivingDirectionsInfo()
        } else if let result = result as? DrivingDirections {
            if let duration = result.routes.first?.legs.first?.duration {
                durationLabel.text = duration.text + SnapXEatsDirectionConstants.durationTextPrefix
            }
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
    
    @IBAction func uberButtonAction(_ sender: UIButton) {
        if let url = URL(string: UberAppConstants.urlscheme), UIApplication.shared.canOpenURL(url) {
            showConfirmationPopupwithMessage(message: SnapXEatsAlertMessages.uberRedirectConfirmation, forURL: url)
        } else {
            if let appstoreURL = URL(string: UberAppConstants.appstoreURL) {
                showConfirmationPopupwithMessage(message: SnapXEatsAlertMessages.uberInstallConfirmation, forURL: appstoreURL)
            }
        }
    }
    
    @IBAction func timingButtonAction(_ sender: UIButton) {
        showRestaurantTimingsPopover(onView: sender)
    }
    
    private func showConfirmationPopupwithMessage(message: String, forURL url: URL) {
        let confirmationAlert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: SnapXEatsAlertButtonTitles.yes, style: .default) { (_) in
            UIApplication.shared.openURL(url)
        }
        let rejectAction = UIAlertAction(title: SnapXEatsAlertButtonTitles.notnow, style: .default, handler: nil)
        confirmationAlert.addAction(rejectAction)
        confirmationAlert.addAction(confirmAction)
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func getRestaurantDetails() {
        if let restaurantId = restaurant.restaurant_info_id {
            showLoading()
            presenter?.restaurantDetailsRequest(restaurantId:restaurantId)
        }
    }
    
    private func showRestaurantDetails() {
        if let details = restaurantDetails {
            restaurantNameLabel.text = details.name ?? SnapXEatsAppDefaults.emptyString
            restaurantAddressLabel.text = details.address ?? SnapXEatsAppDefaults.emptyString
            specialities = details.specialities
            specialityCollectionView.reloadData()
            setupImageSlideshowWithPhotos(photos: details.photos)
            restaurantTimingButton.isEnabled = details.timings.count > 0 ? true : false
            restaurantTimingLabel.text = getRestaurantTimingDisplayText(details: details)
        }
    }
    
    private func getRestaurantTimingDisplayText(details: RestaurantDetails) -> String {
        
        var timingStr = SnapXEatsAppDefaults.emptyString
        if details.isOpenNow == false {
             return restaurantTimingConstants.close
        } else if details.isOpenNow == true {
            let today = Date().dayOfWeek()
            for timing in details.timings {
                if timing.day == today {
                    timingStr = timing.time ?? SnapXEatsAppDefaults.emptyString
                }
            }
            return restaurantTimingConstants.open + " " + timingStr
        }
        return SnapXEatsAppDefaults.emptyString
    }
    
    private func getSortedRestaurantTimings() -> [RestaurantTiming]? {
        let sortedTimings = restaurantDetails?.timings.sorted(by: { (item1, item2) -> Bool in
            if let weekdayInt1 = weekDays[item1.day!], let weekdayInt2 = weekDays[item2.day!] {
                return weekdayInt1 < weekdayInt2
            }
            return false
        })
        return sortedTimings
    }
    
    private func showRestaurantTimingsPopover(onView sender: UIButton) {
        if let timings = getSortedRestaurantTimings() {
            let popController = self.storyboard?.instantiateViewController(withIdentifier: SnapXEatsStoryboardIdentifier.restaurantTimingsViewController) as! RestaurantTimingViewController
            
            popController.timings = timings
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = sender
            popController.popoverPresentationController?.sourceRect = sender.bounds
            self.present(popController, animated: true, completion: nil)
        }
    }
    
    private func getDrivingDirectionsInfo() {
        if let details = restaurantDetails, let restaurantLat = details.latitude, let restaurantLong = details.longitude  {
            let origin = "\(SelectedPreference.shared.location.latitude),\(SelectedPreference.shared.location.longitude)"
            let destination = "\(restaurantLat),\(restaurantLong)"
            presenter?.drivingDirectionsRequest(origin: origin, destination: destination)
        }
    }
}

extension RestaurantDetailsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
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
