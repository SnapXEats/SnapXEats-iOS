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


class LocationViewController: BaseViewController, StoryboardLoadable {
    
    // MARK: Properties
    private var cuiseItems = [Cuisine]()
    private let itemsPerRow: CGFloat = 2
    private let defaultLocationTitle = "Select Location"
    private let locationTitleTopInset: CGFloat = 5
    private let locationTitleLeftInsetMargin: CGFloat = 15.0
    
    let userPreference = UserPreference()
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 30.0, right: 20.0)
    var presenter: LocationPresentation?
    var selectedCuisineIndexes = NSMutableArray()
    
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
        
        setCuisinePreferences()
        resetCollectionView()
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
        locationManager.delegate = self
        setLocationTitle(locationName: selectedPreference.location.locationName)
        registerNotification()
        
        if !locationEnabled {
            verifyLocationService()
        }
    }

    @IBAction func setNewLocation(_ sender: Any) {
        stopLocationManager()
        unRegisterNotification()
        presenter?.selectLocation()
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        //Menu Button Action
        let router = RootRouter.singleInstance
        router.drawerController.setDrawerState(.opened, animated: true)
    }
    
    private func configureView() {
        topView.addBorder(ofWidth: 1.0, withColor: UIColor.rgba(202.0, 202.0, 202.0, 1), radius: 1.0)
        registerCellForNib()
    }
    
    private func setLocationTitle(locationName: String) {
        let locationButtonTitle = (locationName == SnapXEatsAppDefaults.emptyString) ? defaultLocationTitle : locationName
        self.userLocation.setTitle("\(locationButtonTitle)", for: .normal)
        userLocation.titleLabel?.sizeToFit()
        let leftInset = (userLocation.titleLabel?.frame.size.width)! + locationTitleLeftInsetMargin
        userLocation.imageEdgeInsets = UIEdgeInsetsMake(locationTitleTopInset, leftInset, 0, -leftInset);
    }
    
    @objc override func internetConnected() {
        if locationEnabled == false {
          verifyLocationService()
        }
    }
    
    func registerCellForNib() {
        let nib = UINib(nibName: SnapXEatsStoryboardIdentifier.locationCuisineCollectionCellIdentifier, bundle: nil)
        cuisinCollectionView.register(nib, forCellWithReuseIdentifier: SnapXEatsStoryboardIdentifier.locationCellReuseIdentifier)
    }
    
    override func success(result: Any?) {
        if let result = result as? CuisinePreference {
            hideLoading()
            cuiseItems = result.cuisineList
            cuisinCollectionView.reloadData()
        }
    }
    
    private func setCuisinePreferences() {
        for (_, index) in selectedCuisineIndexes.enumerated() {
            let cuisine = cuiseItems[(index as! Int)]
            selectedPreference.selectedCuisine.append(cuisine.cuisineName ?? "")
        }
    }
    
    private func resetCollectionView() {
        selectedCuisineIndexes.removeAllObjects()
        cuisinCollectionView.reloadData()
    }
}

extension LocationViewController: LocationView {
    
    // TODO: implement view output methods
    func initView() {
        customizeNavigationItem(isDetailPage: false)
        configureView()
    }
}

extension LocationViewController: CLLocationManagerDelegate, SnapXEatsUserLocation {

    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        verifyLocationService()
    }
    
    //if we have no permission to access user location, then ask user for permission.
    private func verifyLocationService() {
        showSettingDialog()
    }
    
     func checkLocationStatus() {
        let status = CLLocationManager.authorizationStatus()
        switch status  {
        case .authorizedWhenInUse,.authorizedAlways:
            if checkRechability() {
                showLoading()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        case .denied:
            if permissionDenied == false {
                permissionDenied = true
                presenter?.selectLocation()

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
            showAddressForLocation(locations: locations) {[weak self] (locality: String?, subAdministrativeArea: String? ) in
                if let locality = locality {
                    self?.setLocationTitle(locationName: locality)
                } else if let area = subAdministrativeArea {
                    self?.setLocationTitle(locationName: area)
                }
                self?.hideLoading()
                self?.sendCuiseRequest()
            }
    }
    
    private func showAddressForLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {[weak self] (placemarksArray, error) in
            let enable = self?.checkRechability() ?? false
            if let placemarksArray = placemarksArray, placemarksArray.count > 0 && enable { // app was crashin on on/off internet
                // strongSelf.hideLoading()
                let placemark = placemarksArray.first // Get the First Address from List
                self?.selectedPreference.location.latitude =  Double(placemark?.location?.coordinate.latitude ?? 0)
                self?.selectedPreference.location.longitude = Double(placemark?.location?.coordinate.longitude ?? 0)
                if let locality = placemark?.subLocality {
                    self?.setLocationTitle(locationName: locality)
                } else if let area = placemark?.subAdministrativeArea {
                    self?.setLocationTitle(locationName: area)
                }
                self?.sendCuiseRequest()
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
        //2
        let paddingSpace: CGFloat = 12 + sectionInsets.left * 2
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
