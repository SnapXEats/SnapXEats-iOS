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
    
    @IBAction func closeLocationView(_ sender: Any) {
        presenter?.closeLocationView(selectedPreference: selectedPreference)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        setLocationTitle()
        registerNotification()
        sendCuiseRequest()
    }
    
    @IBAction func setNewLocation(_ sender: Any) {
        stopLocationManager()
        unRegisterNotification()
        presenter?.selectLocation()
    }
    
    private func configureView() {
        topView.addShadow()
        registerCellForNib()
    }
    
    private func setLocationTitle() {
        let locationTitle = self.selectedPreference.location.locationName
        if locationTitle != SnapXEatsConstant.emptyString {
            self.userLocation.setTitle("\(locationTitle)", for: .normal)
        }
    }
    
    @objc override func internetConnected() {
        if locationEnabled == false {
          verigyLocationService()
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
}

extension LocationViewController: LocationView {
    
    // TODO: implement view output methods
    func initView() {
        enableDoneButton()
        configureView()
    }
}

extension LocationViewController: CLLocationManagerDelegate, SnapXEatsUserLocation {

    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        verigyLocationService()
    }
    
    //if we have no permission to access user location, then ask user for permission.
    private func verigyLocationService() {
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
        if checkRechability() && cuiseItems.count == 0 && !isProgressHUD && locationEnabled {
            showLoading()
            presenter?.cuisinePreferenceRequest(selectedPreference: selectedPreference)
        }
    }
    //this method is called by the framework on locationManager.requestLocation();
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            showAddressForLocation(locations: locations) {[weak self] (locality: String?, subAdministrativeArea: String? ) in
                if let locality = locality {
                    self?.userLocation.setTitle("\(locality)", for: .normal)
                } else if let area = subAdministrativeArea {
                    self?.userLocation.setTitle("\(area)", for: .normal)
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
                    self?.userLocation.setTitle("\(locality)", for: .normal)
                } else if let area = placemark?.subAdministrativeArea {
                    self?.userLocation.setTitle("\(area)", for: .normal)
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
            selectedPreference.selectedCuisine.remove(at: indexPath.row)
        } else {
            selectedCuisineIndexes.add(indexPath.row)
            let item = cuiseItems[indexPath.row]
            selectedPreference.selectedCuisine.append(item.cuisineName ?? "")
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
