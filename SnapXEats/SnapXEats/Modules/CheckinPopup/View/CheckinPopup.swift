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
    var restaurant: CheckInRestaurant?
    var router: CheckinPopupRouter?
    var restaurantList = [Restaurant]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var userID = LoginUserPreferences.shared.loginUserID
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
        if let id = restaurant.restaurantId, id != SnapXEatsConstant.emptyString {
            self.removeFromSuperview()
            if LoginUserPreferences.shared.isLoggedIn {
                showLoading()
                presenter?.checkinIntoRestaurant(restaurantId: id)
            } else {
                checkInNonLoggedInUser()
                checkinPopupDelegate?.userDidChekintoRestaurant(restaurantID: id)
            }
        }
    }
    
    override func success(result: Any?) {
        if let rewardPoints = result as? RewardPoints {
            checkInUser()
            self.removeFromSuperview()
            router?.showRewardPointsPopup(parent: self, points: rewardPoints.points)
        } else if let restaurantList = result as? RestaurantsList {
            if restaurantList.restaurants.count > 1 {
                self.restaurantList = restaurantList.restaurants
                showRestaurantList()
                nearbyRestaurantsErrorLabel.isHidden = self.restaurantList.count == 0 ? false : true
                restaurantListTableView.reloadData()
            } else if restaurantList.restaurants.count == 1 {
                restaurant =  mapRestaurantAndCheckInRestaurant(restaurnat: restaurantList.restaurants[0])
                showRestaurantInfo()
            } else {
                self.removeFromSuperview()
                router?.showNoRestaurantPopup()
            }
        }
    }
    
    func checkInUser() {
        if let restaurantID = self.restaurant?.restaurantId {
            let checkIn = CheckInModel()
            checkIn.userID = userID
            checkIn.restaurantID = restaurantID
            checkIn.checkIntime =  "\(Date().timeIntervalSince1970)"
            CheckInHelper.shared.checkInUser(checkIn: checkIn)
        }
    }
    
    func checkInNonLoggedInUser() {
        if let restaurantID = self.restaurant?.restaurantId {
            let checkIn = CheckInModel()
            checkIn.userID = SnapXNonLoggedInUserConstants.snapX_nonLogedIn_CheckIn
            checkIn.restaurantID = restaurantID
            checkIn.checkIntime =  "\(Date().timeIntervalSince1970)"
            CheckInHelper.shared.nonLoggedInUserCheckIn(checkIn: checkIn)
        }
    }
    
    func setupPopup(frame: CGRect, restaurant: CheckInRestaurant?) {
        
        self.frame = frame
        self.restaurant = restaurant
        checkinButton.layer.cornerRadius = checkinButton.frame.height/2
        restaurantLogoImageView.layer.cornerRadius = restaurantLogoImageView.frame.height/2
        containerView.layer.cornerRadius = popupConstants.containerRadius
        restaurantListTableView.tableFooterView = UIView()
        if let restaurant = self.restaurant {
            restaurantNameLabel.text = restaurant.name
        }
        registerCellForNib()
        checkIfRestaurantIsAvailable()
    }
    
    private func registerCellForNib() {
        let tableCellNib = UINib(nibName: SnapXEatsNibNames.restaurantListTableViewCell, bundle: nil)
        restaurantListTableView.register(tableCellNib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.restaurantListTableView)
    }
    
    private func checkIfRestaurantIsAvailable() {
        restaurant == nil ?  checkLocationStatus() : showRestaurantInfo()
    }
    
    private func showRestaurantList() {
        restaurantInfoView.isHidden = true
        restaurantListView.isHidden = false
        checkinButton.isEnabled = false
        checkinButton.alpha = 0.5
        
    }
    
    private func showRestaurantInfo() {
        restaurantInfoView.isHidden = false
        restaurantListView.isHidden = true
        
        if let restaurant = restaurant {
            restaurantNameLabel.text = restaurant.name ?? ""
            restaurantTypeLabel.text = restaurant.type ?? ""
            if let url = URL(string: restaurant.logoImage ?? "") {
                let placeholderImage = UIImage(named: SnapXEatsImageNames.restaurant_logo)!
                restaurantLogoImageView.maskCircle(anyImage: placeholderImage)
                restaurantLogoImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
        }
    }
    
    private func getRestaurantList() {
        if let currentLocation = self.currentLocation {
            showActivityIndicator()
            // This is used for testing as current location is not from US
            presenter?.getNearbyRestaurantList(latitude: String(currentLocation.coordinate.latitude), longitude: String(currentLocation.coordinate.longitude))
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
        if let restaurantID = self.restaurant?.restaurantId {
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
        self.restaurant = mapRestaurantAndCheckInRestaurant(restaurnat: restaurantList[indexPath.row])
    }
    
    func mapRestaurantAndCheckInRestaurant(restaurnat: Restaurant) -> CheckInRestaurant? {
        if let id = restaurnat.restaurant_info_id {
            let checkINRestaurant = CheckInRestaurant()
            checkINRestaurant.restaurantId = id
            checkINRestaurant.name = restaurnat.restaurant_name
            checkINRestaurant.latitude = restaurnat.latitude
            checkINRestaurant.longitude = restaurnat.longitude
            checkINRestaurant.price = restaurnat.price
            checkINRestaurant.type = restaurnat.type
            checkINRestaurant.logoImage = restaurnat.logoImage
            return checkINRestaurant
        }
        return nil
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
