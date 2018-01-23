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

enum LocationResourceIdentifiler {
    static let cellReuseIdentifier = "CuisineCell"
    static  let cuisineCollectionCellIdentifier = "CuisineCollectionViewCell"
}
class LocationViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties
    private var cuiseItems = [Cuisine]()
   // private let cuisine = CuisinePrefernce(map: <#Map#>)
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 30.0, right: 20.0)
    var presenter: LocationPresentation?

    // MARK: Lifecycle
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var cuisinCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
   
    @IBAction func closeLocationView(_ sender: Any) {
        presenter?.closeLocationView()
    }
    
    @IBOutlet weak var userLocation: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        configureView()
    }
    
    @IBAction func setNewLocation(_ sender: Any) {
        presenter?.selectLocation()
    }
    func configureView() {
        topView.addShadow()
        registerCellForNib()
    }
    
    func registerCellForNib() {
        let nib = UINib(nibName: LocationResourceIdentifiler.cuisineCollectionCellIdentifier, bundle: nil)
        cuisinCollectionView.register(nib, forCellWithReuseIdentifier: LocationResourceIdentifiler.cellReuseIdentifier)
    }
}

extension LocationViewController: LocationView {
   
    
    // TODO: implement view output methods
    func initView() {
        locationManager = CLLocationManager()
        isAuthorizedtoGetUserLocation()
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    //if we have no permission to access user location, then ask user for permission.
    func isAuthorizedtoGetUserLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager?.requestWhenInUseAuthorization()
        } else  if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            showLoading()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
            presenter?.cuisinePreferenceRequest()
          //  let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
          //  print("locations = \(locValue.latitude) \(locValue.longitude)")
        }//if authorized
    }

    //this method is called by the framework on locationManager.requestLocation();
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        locationManager?.stopUpdatingLocation()
        locationManager = nil
        // Get user's current location name
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {[weak self] (placemarksArray, error) in
             guard let strongSelf = self else { return }
            if (placemarksArray?.count)! > 0 {
                
                let placemark = placemarksArray?.first
                let number = placemark!.subThoroughfare
                let bairro = placemark!.subLocality
                let street = placemark!.thoroughfare
                strongSelf.userLocation.titleLabel?.text = "\(street!), \(number!) - \(bairro!)"
                strongSelf.hideLoading()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationResourceIdentifiler.cellReuseIdentifier, for: indexPath) as! CuisineCollectionViewCell
        cell.configureCell(cuisineItem: cuiseItems[indexPath.row])
        return cell
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

//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
}


extension LocationViewController  {
    func success(result: Any?) {
        if let result = result {
            let cuises = result as! CuisinePreference
            cuiseItems = cuises.cuisineList
            cuisinCollectionView.reloadData()
        }
    }
    
    func error(result: NetworkResult) {
        
    }
    
    func cancel(result: NetworkResult) {
        
    }
    
    func noInternet(result: NetworkResult) {
        
    }
}