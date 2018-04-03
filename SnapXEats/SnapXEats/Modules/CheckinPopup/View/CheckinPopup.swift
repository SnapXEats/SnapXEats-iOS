//
//  CheckinPopup.swift
//  SnapXEats
//
//  Created by synerzip on 21/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import CoreLocation

protocol CheckinPopUpActionsDelegate: class {
    func userDidChekintoRestaurant(restaurantID: String)
}

class CheckinPopup: SnapXEatsView, CheckinPopupView {
    
    private enum popupConstants {
        static let containerRadius: CGFloat = 6.0
    }
    
    weak var checkinPopupDelegate: CheckinPopUpActionsDelegate?
    var presenter: CheckinPopupPresenter?
    var restaurant: Restaurant?
    var router: CheckinPopupRouter?
    var restaurantList = [Restaurant]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var restaurantInfoView: UIView!
    @IBOutlet var restaurantListView: UIView!
    @IBOutlet var restaurantListTableView: UITableView!
    @IBOutlet var checkinButton: UIButton!
    @IBOutlet var restaurantLogoImageView: UIImageView!
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantTypeLabel: UILabel!
    @IBOutlet var nearbyRestaurantsErrorLabel: UILabel!
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func checkinButtonAction(_ sender: UIButton) {
        guard let restaurant = self.restaurant else {
            return
        }
        
        // Call Checkin API only if User is Logged in and then Show Reward Points popup else directly go to snapnShare Home page
        if let id = restaurant.restaurant_info_id {
            if LoginUserPreferences.shared.isLoggedIn {
            showLoading()
            presenter?.checkinIntoRestaurant(restaurantId: id)
        } else {
            checkinPopupDelegate?.userDidChekintoRestaurant(restaurantID: id)
            }
        }
    }
    
    override func success(result: Any?) {
        if let rewardPoints = result as? RewardPoints {
            self.removeFromSuperview()
            router?.showRewardPointsPopup(parent: self, points: rewardPoints.points)
        } else if let restaurantList = result as? RestaurantsList {
            self.restaurantList = restaurantList.restaurants
            nearbyRestaurantsErrorLabel.isHidden = self.restaurantList.count == 0 ? false : true
            restaurantListTableView.reloadData()
        }
    }
    
    func setupPopup(frame: CGRect, restaurant: Restaurant) {
        self.frame = frame
        self.restaurant = restaurant
        checkinButton.layer.cornerRadius = checkinButton.frame.height/2
        restaurantLogoImageView.layer.cornerRadius = restaurantLogoImageView.frame.height/2
        containerView.layer.cornerRadius = popupConstants.containerRadius
        restaurantListTableView.tableFooterView = UIView()
        if let restaurant = self.restaurant, let name = restaurant.restaurant_name {
            restaurantNameLabel.text = name
        }
        registerCellForNib()
        checkIfRestaurantIsAvailable()
    }
    
    private func registerCellForNib() {
        let tableCellNib = UINib(nibName: SnapXEatsNibNames.restaurantListTableViewCell, bundle: nil)
        restaurantListTableView.register(tableCellNib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.restaurantListTableView)
    }
    
    private func checkIfRestaurantIsAvailable() {
        //TODO:  When user goes to direction page restaurant from UserdishReview needs to be updated which should be used for Check in once user location is detected within certain distance from this restaurant
        LoginUserPreferences.shared.userDishReview.restaurant == nil ? showRestaurantList() : showRestaurantInfo()
    }
    
    private func showRestaurantList() {
        restaurantInfoView.isHidden = true
        restaurantListView.isHidden = false
        checkinButton.isEnabled = false
        checkinButton.alpha = 0.5
        checkLocationStatus()
    }
    
    private func showRestaurantInfo() {
        restaurantInfoView.isHidden = false
        restaurantListView.isHidden = true
        
        if let restaurant = LoginUserPreferences.shared.userDishReview.restaurant {
            restaurantNameLabel.text = restaurant.restaurant_name ?? ""
            restaurantTypeLabel.text = restaurant.type ?? ""
            if let url = URL(string: restaurant.logoImage ?? "") {
                let placeholderImage = UIImage(named: SnapXEatsImageNames.restaurant_logo)!
                restaurantLogoImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
        }
    }
    
    private func getRestaurantList() {
        if let currentLocation = self.currentLocation {
            showActivityIndicator()
            // This is used for testing as current location is not from US
            presenter?.getNearbyRestaurantList(latitude: "40.7014", longitude: "-74.0151")
            //presenter?.getNearbyRestaurantList(latitude: String(currentLocation.coordinate.latitude), longitude: String(currentLocation.coordinate.longitude))
        }
    }
    
    private func showActivityIndicator() {
        DispatchQueue.main.async { // It was not Showing Indicator without dispatching Async on main thread. Some strenge Behaviour
            self.showLoading()
        }
    }
}

extension CheckinPopup: RewardPopupActionsDelegate {
    func popupDidDismiss(_ popup: RewardPointsPopup) {
        if let restaurantID = self.restaurant?.restaurant_info_id {
           checkinPopupDelegate?.userDidChekintoRestaurant(restaurantID: restaurantID)
        }
    }
}

extension CheckinPopup: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.restaurantListTableView, for: indexPath) as! RestaurantListTableViewCell
        cell.configureRestaurantCell(restaurant: restaurantList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkinButton.isEnabled = true
        checkinButton.alpha = 1.0
        self.restaurant = restaurantList[indexPath.row]
    }
}

extension CheckinPopup: CLLocationManagerDelegate {
    
    //TODO: Use Common Location related functionality from SnapXEatsUserLocation. It will be used to show settings popup if user has denied permission for Location and other use cases.
    func checkLocationStatus() {
        let status = CLLocationManager.authorizationStatus()
        switch status  {
        case .authorizedWhenInUse, .authorizedAlways:
            if checkRechability() {
                showActivityIndicator()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
            }
        case .denied: print("....... Location not enabled .......")
            //showSettingDialog()
        case  .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.first
        self.currentLocation = newLocation
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        getRestaurantList()
    }
}
