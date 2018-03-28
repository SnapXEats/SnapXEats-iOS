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
    func userDidChekintoRestaurant(restaurant: Restaurant)
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
    
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func checkinButtonAction(_ sender: UIButton) {
        guard let restaurant = self.restaurant else {
            return
        }
        
        // Call Checkin API only if User is Logged in and then Show Reward Points popup else directly go to snapnShare Home page
        if let id = restaurant.restaurant_info_id, LoginUserPreferences.shared.isLoggedIn {
            showLoading()
            presenter?.checkinIntoRestaurant(restaurantId: id)
        } else {
            checkinPopupDelegate?.userDidChekintoRestaurant(restaurant: restaurant)
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
    
    override func success(result: Any?) {
        if let rewardPoints = result as? RewardPoints {
            self.removeFromSuperview()
            router?.showRewardPointsPopup(parent: self, points: rewardPoints.points)
        } else if let restaurantList = result as? RestaurantsList {
            self.restaurantList = restaurantList.restaurants
            restaurantListTableView.reloadData()
        }
    }
    
    private func registerCellForNib() {
        let tableCellNib = UINib(nibName: SnapXEatsNibNames.restaurantListTableViewCell, bundle: nil)
        restaurantListTableView.register(tableCellNib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.restaurantListTableView)
    }
    
    private func showRestaurantList() {
        restaurantInfoView.isHidden = true
        restaurantListView.isHidden = false
        
        checkIfRestaurantIsAvailable()
    }
    
    private func showRestaurantInfo() {
        restaurantInfoView.isHidden = false
        restaurantListView.isHidden = true
    }
    
    private func checkIfRestaurantIsAvailable() {
        //TODO:  Add Condition to check if there is already a restaurant which is detected as Nearby automatically from CLLocation. If not then only get User current location and get nearby restaurants.
        checkLocationStatus()
    }
    
    private func getRestaurantList() {
        if let currentLocation = self.currentLocation {
            showActivityIndicator()
            presenter?.getNearbyRestaurantList(latitude: "40.7014", longitude: "-74.0151")
//            presenter?.getNearbyRestaurantList(latitude: String(currentLocation.coordinate.latitude), longitude: String(currentLocation.coordinate.longitude))
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
        if let restaurant = self.restaurant {
           checkinPopupDelegate?.userDidChekintoRestaurant(restaurant: restaurant)
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
