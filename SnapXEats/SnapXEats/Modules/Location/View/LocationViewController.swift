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
    
    private var enabledLocationSharing = false
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 30.0, right: 20.0)
    var presenter: LocationPresentation?
    var selectedCuisineIndexes = NSMutableArray()
    
    // MARK: Lifecycle
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var cuisinCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userLocation: UIButton!
    
    @IBAction func closeLocationView(_ sender: Any) {
        enabledLocationSharing ? presenter?.closeLocationView()
            : verigyLocationService()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    @IBAction func setNewLocation(_ sender: Any) {
        enabledLocationSharing ? presenter?.selectLocation()
            : verigyLocationService()
    }
    func configureView() {
        topView.addShadow()
        registerCellForNib()
    }
    
    func registerCellForNib() {
        let nib = UINib(nibName: SnapXEatsStoryboardIdentifier.locationCuisineCollectionCellIdentifier, bundle: nil)
        cuisinCollectionView.register(nib, forCellWithReuseIdentifier: SnapXEatsStoryboardIdentifier.locationCellReuseIdentifier)
    }
    
    override func success(result: Any?) {
        if let result = result {
            let cuises = result as! CuisinePreference
            cuiseItems = cuises.cuisineList
            cuisinCollectionView.reloadData()
        }
    }
}

extension LocationViewController: LocationView {
    
    // TODO: implement view output methods
    func initView() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        configureView()
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        verigyLocationService()
    }
    
    //if we have no permission to access user location, then ask user for permission.
    private func verigyLocationService() {
        locationManager?.delegate = self
        if checkRechability() {
            CLLocationManager.locationServicesEnabled() ? checkLocationStatus() : showSettingDialog()
        }
    }
    
    private func checkLocationStatus() {
        let status = CLLocationManager.authorizationStatus()
        switch status  {
        case .authorizedWhenInUse:
            sendCuiseRequest()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
            enabledLocationSharing = true
        case .denied:
            showSettingDialog()
        case  .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        default: break
        }
    }
    
    private func showUserLocationDialog() {
        SnapXAlert.singleInstance.createAlert(alertTitle: SnapXEatsLocationConstant.locationAlertTitle, message: SnapXEatsLocationConstant.locationAlertMessage, forView: self)
        SnapXAlert.singleInstance.show()
    }
    
    func showSettingDialog() {
        let alertController = UIAlertController(title: NSLocalizedString(SnapXEatsLocationConstant.locationAlertTitle, comment: ""), message: NSLocalizedString(SnapXEatsLocationConstant.locationAlertMessage, comment: ""), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { [weak self ](UIAlertAction) in
            guard let strongSelf = self else { return }
            strongSelf.sendCuiseRequest()
        })
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func sendCuiseRequest() {
        if checkRechability() && cuiseItems.count == 0 {
            showLoading()
            presenter?.cuisinePreferenceRequest()
        }
    }
    //this method is called by the framework on locationManager.requestLocation();
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if checkRechability() {
            let location = locations.first!
            locationManager?.stopUpdatingLocation()
            locationManager = nil
            // Get user's current location Address
            showAddressForLocation(location: location)
        }
    }
    
    private func showAddressForLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {[weak self] (placemarksArray, error) in
            guard let strongSelf = self else { return }
            
            if (placemarksArray?.count)! > 0 {
                strongSelf.hideLoading()
                
                let placemark = placemarksArray?.first // Get the First Address from List
                if let locality = placemark?.subLocality {
                    strongSelf.userLocation.setTitle("\(locality)", for: .normal)
                } else if let area = placemark?.subAdministrativeArea {
                    strongSelf.userLocation.setTitle("\(area)", for: .normal)
                }
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
        collectionView.reloadItems(at: [indexPath])
    }
}

extension LocationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace: CGFloat = 12 + sectionInsets.left*2
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem*2/3 + 35)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
}
