//
//  LocationViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 18/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import RealmSwift

class LocationViewController: BaseViewController, StoryboardLoadable {
    
    // MARK: Properties
    private var cuiseItems = [CuisineItem]()
    private let itemsPerRow: CGFloat = 2
    private let defaultLocationTitle = "Select Location"
    private let locationTitleTopInset: CGFloat = 5
    private let locationTitleLeftInsetMargin: CGFloat = 15.0
    private let storedLocation = LocationModel()
    
    let userPreference = UserPreference()
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 30.0, right: 20.0)
    var presenter: LocationPresentation?
    var selectedCuisineIndexes = NSMutableArray()
    var cuisinePreference: [CuisineItem] {
        return PreferenceHelper.shared.getStoredCuisneList()
    }
    var currentView: UIViewController {
        get {
            return self
        }
    }
    
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cuisinCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userLocation: UIButton!
    
    private var locationEnabled: Bool {
        get {
            return (selectedPreference.location.latitude != 0.0 && selectedPreference.location.longitude != 0.0)
        }
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false // UnHide navigation bar when moved to Next Page. Not Used View will disappear because it unhides NvBar even if Drawer is opened.
        reset() // Reset view state unregister observer and location manager
        presenter?.closeLocationView(selectedPreference: selectedPreference, parent: self.navigationController!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        enableDoneButton()
        setLocationTitle(locationName: selectedPreference.location.locationName)
        registerNotification()
        sendCuiseRequest()
        selectedPreference.selectedCuisine.removeAll()
    }
    
    @IBAction func setNewLocation(_ sender: Any) {
        stopLocationManager()
        unRegisterNotification()
        presenter?.selectLocation(parent: self)
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        //Menu Button Action
        presenter?.updatedDrawerState(state: .opened)
    }
    
    private func configureView() {
        topView.addBorder(ofWidth: 1.0, withColor: UIColor.rgba(202.0, 202.0, 202.0, 1), radius: 1.0)
        registerCellForNib()
    }
    
    private func reset() {
        stopLocationManager()
        unRegisterNotification()
        setCuisinePreferences()
        resetCollectionView()
    }
    private func setLocationTitle(locationName: String) {
        let locationButtonTitle = (locationName == SnapXEatsAppDefaults.emptyString) ? defaultLocationTitle : locationName
        self.userLocation.setTitle("\(locationButtonTitle)", for: .normal)
        userLocation.titleLabel?.sizeToFit()
        let leftInset = (userLocation.titleLabel?.frame.size.width)! + locationTitleLeftInsetMargin
        userLocation.imageEdgeInsets = UIEdgeInsetsMake(locationTitleTopInset, leftInset, 0, -leftInset)
        if selectedPreference.location.locationName != locationName {
            selectedPreference.location.locationName = locationName
        }
    }
    
    func storeLocation() {
        storedLocation.logitude  = selectedPreference.location.longitude
        storedLocation.latitue   = selectedPreference.location.latitude
        storedLocation.placeName = selectedPreference.location.locationName
        storedLocation.userID  = selectedPreference.loginUserPreference.loginUserID
        presenter?.storeLocation(location: storedLocation)
    }
    
    func checkStoredLocation() -> Bool {
        if let location = presenter?.getLocation(userID: selectedPreference.loginUserPreference.loginUserID), let place = location.placeName {
            selectedPreference.location.longitude = location.logitude
            selectedPreference.location.latitude = location.latitue
            setLocationTitle(locationName: place)
            return true
        }
        return false
    }
    
    @objc override func internetConnected() {
        locationEnabled ? sendCuiseRequest() : verifyLocationService()
    }
    
    func registerCellForNib() {
        let nib = UINib(nibName: SnapXEatsStoryboardIdentifier.locationCuisineCollectionCellIdentifier, bundle: nil)
        cuisinCollectionView.register(nib, forCellWithReuseIdentifier: SnapXEatsStoryboardIdentifier.locationCellReuseIdentifier)
    }
    
    override func success(result: Any?) {
        if let result = result as? CuisinePreference {
            hideLoading()
            cuiseItems = result.cuisineList.sorted { $0.name! < $1.name! }
            setUserSelectedFoodPrefercne()
            enableDoneButton()
            cuisinCollectionView.reloadData()
        }
    }
    
    private func setCuisinePreferences() {
        for (_, index) in selectedCuisineIndexes.enumerated() {
            let cuisine = cuiseItems[(index as! Int)]
            if let cuisineId = cuisine.itemID {
                selectedPreference.selectedCuisine.append(cuisineId)
            }
        }
    }
    
    private func resetCollectionView() {
        selectedCuisineIndexes.removeAllObjects()
        cuisinCollectionView.reloadData()
    }
    
    private func setUserSelectedFoodPrefercne() {
        for (index, cuiseItem) in cuiseItems.enumerated() {
            for cuisine in cuisinePreference {
                if let id = cuiseItem.itemID , cuisine.itemID == id, (cuisine.isLiked || cuisine.isFavourite) {
                    selectedCuisineIndexes.add(index)
                }
            }
        }
        
    }
}

extension LocationViewController: LocationView {
    
    // TODO: implement view output methods
    func initView() {
        customizeNavigationItem(isDetailPage: false)
        configureView()
        if checkStoredLocation() == false {
            verifyLocationService()
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate, SnapXEatsUserLocation {
    
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        verifyLocationService()
    }
    
    //if we have no permission to access user location, then ask user for permission.
    private func verifyLocationService() {
        locationManager.delegate = self // set the delegate again 
        showSettingDialog()
    }
    
    func checkLocationStatus() {
        let status = CLLocationManager.authorizationStatus()
        switch status  {
        case .authorizedWhenInUse, .authorizedAlways:
            if checkRechability() {
                showLoading()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        case .denied:
            if permissionDenied == false {
                permissionDenied = true
                presenter?.selectLocation(parent: self)
                
            } else  {
                showSettingDialog()
            }
        case  .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
    
    private func sendCuiseRequest() {
        if checkRechability() && !isProgressHUD && locationEnabled {
            showLoading()
            presenter?.cuisinePreferenceRequest(selectedPreference: selectedPreference)
        }
    }
    //this method is called by the framework on locationManager.requestLocation();
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        showAddressForLocation(locations: locations) {[weak self] (result: NetworkResult) in
            switch result {
            case .success(let value):
                let data: (String?, String?) = value as! (String?, String?)
                if let locality = data.0 {
                    self?.setLocationTitle(locationName: locality)
                } else if let area = data.1 {
                    self?.setLocationTitle(locationName: area)
                }
                self?.storeLocation()
                self?.hideLoading()
                self?.sendCuiseRequest()
                
            case .noInternet:
                self?.hideLoading()
            default:
                break
            }
        }
    }
}


extension LocationViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cuiseItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnapXEatsStoryboardIdentifier.locationCellReuseIdentifier, for: indexPath) as! CuisineCollectionViewCell
        let isItemSelected = selectedCuisineIndexes.contains(indexPath.row) ? true : false
        cell.configureCell(cuisineItem: cuiseItems[indexPath.row], isSelected: isItemSelected)
        self.hideLoading()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCuisineIndexes.contains(indexPath.row) {
            selectedCuisineIndexes.remove(indexPath.row)
        } else {
            selectedCuisineIndexes.add(indexPath.row)
        }
        enableDoneButton()
        collectionView.reloadItems(at: [indexPath])
    }
    
    private func enableDoneButton() {
        let state =  selectedCuisineIndexes.count > 0 && locationEnabled
        doneButton.isUserInteractionEnabled = state
        doneButton.alpha = state == true ? 1.0 : 0.5
    }
}

extension LocationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace: CGFloat = 5 + sectionInsets.left * 2
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 2/3 + 35)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
}
