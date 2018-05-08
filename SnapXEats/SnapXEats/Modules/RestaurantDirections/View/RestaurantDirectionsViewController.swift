//
//  RestaurantDirectionsViewController.swift
//  SnapXEats
//
//  Created by synerzip on 28/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

// To Distingugish between Restaurant marker and Current Location Marker the
class CurrentLocationAnnotation: MKPointAnnotation {
}

class RestaurantDirectionsViewController: BaseViewController, StoryboardLoadable {
    
    private enum locationTitleInsets{
        static let left: CGFloat = 15.0
        static let top: CGFloat = 5.0
    }
    
    private enum mapRouteConstants {
        static let mapViewVisbileRectInsets: CGFloat = 40
        static let routeLineWidth: CGFloat = 3.0
        static let routeLineColor = UIColor.rgba(93.0, 93.0, 93.0, 1.0)
        static let distanceFilterInMeters: Double = 10
    }
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var timingsButton: UIButton!
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantAddressLabel: UILabel!
    @IBOutlet var pricingLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func restaurantTimingButtonAction(_ sender: UIButton) {
        showRestaurantTimingsPopover(onView: sender)
    }
    
    var presenter: RestaurantDirectionsPresentation?
    var restaurantDetails: RestaurantDetails!
    var locationManager =  CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showRestaurantDetails()
    }
    
    @objc override func internetConnected() {
        // Internet is needed only to Show map Route. Other details are coming from earlier Screen
        setupMapViewWithDirections()
    }
    
    private func showRestaurantDetails() {
        restaurantNameLabel.text = restaurantDetails.name ?? ""
        restaurantAddressLabel.text = restaurantDetails.address ?? ""
        timingsButton.setTitle(restaurantDetails.timingDisplayText(), for: .normal)
        timingsButton.titleLabel?.sizeToFit()
        let leftInset = (timingsButton.titleLabel?.frame.size.width)! + locationTitleInsets.left
        timingsButton.imageEdgeInsets = UIEdgeInsetsMake(locationTitleInsets.top, leftInset, 0, -leftInset)
        timingsButton.isEnabled = restaurantDetails.timings.count > 0 ? true : false
        ratingLabel.text = "\(restaurantDetails.rating ?? 0.0)"
        if let price = restaurantDetails.price {
            pricingLabel.text = "\(PricingPreference(rawValue: price)?.displayText() ?? "")"
        }
        
        if let id = restaurantDetails.id, let lat =  restaurantDetails.latitude, let long = restaurantDetails.longitude,
            let name = restaurantDetails.name, let price = restaurantDetails.price {
            let checkINRestaurant = CheckInRestaurant()
            checkINRestaurant.restaurantId = id
            checkINRestaurant.name = name
            checkINRestaurant.latitude = lat
            checkINRestaurant.longitude = long
            checkINRestaurant.price = price
            checkINRestaurant.type = restaurantDetails.restaurant_type
            checkINRestaurant.logoImage = restaurantDetails.photos[0].imageURL ?? ""
            CheckInHelper.shared.checkInRestaurant = checkINRestaurant
        }
        
        // Below 2 line Code will enable SNAP-110 its under testing
       // BackgroundLocationHelper.shared.reset()
       // BackgroundLocationHelper.shared.start()
        setupMapViewWithDirections()
    }
    
    private func addShareButtonOnNavigationItem() {
        let shareButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        shareButton.setImage(UIImage(named: SnapXEatsImageNames.share), for: UIControlState.normal)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
    }
    
    @objc func shareButtonAction() {
        //Share Button Action
    }
    
    private func showRestaurantTimingsPopover(onView sender: UIButton) {
        if let timings = restaurantDetails?.sortedRestaurantTimings() {
            let storyboard = UIStoryboard(name: SnapXEatsStoryboard.restarantDetails, bundle: nil)
            let popController = storyboard.instantiateViewController(withIdentifier: SnapXEatsStoryboardIdentifier.restaurantTimingsViewController) as! RestaurantTimingViewController
            
            popController.timings = timings
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = sender
            popController.popoverPresentationController?.sourceRect = sender.bounds
            self.present(popController, animated: true, completion: nil)
        }
    }
}

extension RestaurantDirectionsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

extension RestaurantDirectionsViewController: RestaurantDirectionsView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.directions, isDetailPage: true)
        ratingView.layer.cornerRadius = ratingView.frame.width/2
        //addShareButtonOnNavigationItem()
    }
}

//MARK: Mapview and Direction related Function
extension RestaurantDirectionsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = mapRouteConstants.routeLineColor
        renderer.lineWidth = mapRouteConstants.routeLineWidth
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "")
        
        // To distinguish between Current Location and Restaurant Marker
        let imageName = (annotation is CurrentLocationAnnotation) ? SnapXEatsImageNames.current_location_marker_icon : SnapXEatsImageNames.marker_icon_selected
        annotationView.image = UIImage(named: imageName)
        annotationView.canShowCallout = false
        return annotationView
    }
    
    private func setupMapViewWithDirections() {
        guard let restaurantLatitude = restaurantDetails.latitude, let restaurantLongitude = restaurantDetails.longitude else {
            return
        }
        
        //TODO: Change this to actual Current Location in Future
        let currentLocation = SelectedPreference.shared.getLatitude()
        let sourceLocation = CLLocationCoordinate2D(latitude: Double(truncating: currentLocation.0 as NSNumber), longitude: Double(truncating: currentLocation.1 as NSNumber))
        let destinationLocation = CLLocationCoordinate2D(latitude: restaurantLatitude, longitude: restaurantLongitude)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // Create Annotations for Source and Destination
        let sourceAnnotation = CurrentLocationAnnotation()
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        mapView.showsCompass = true
        
        // Calculate the direction and Show Route with Navigation
        if checkRechability() {
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            calculateDirectionandShowOnMap(sourceMapItem: sourceMapItem, destinationMapItem: destinationMapItem)
        }
    }
    
    private func calculateDirectionandShowOnMap(sourceMapItem: MKMapItem, destinationMapItem: MKMapItem) {
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error in Finding Routes: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self?.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            // Show Distance in Miles
            let distanceInMiles = response.routes[0].distance*SnapXEatsAppDefaults.meterToMileMultiplier // Convert meters - miles
            self?.distanceLabel.text = String(format:SnapXEatsAppDefaults.restaurantDistance, distanceInMiles)
            
            let rect = route.polyline.boundingMapRect
            let rectInsets = mapRouteConstants.mapViewVisbileRectInsets
            self?.mapView.setVisibleMapRect(rect, edgePadding:
                UIEdgeInsetsMake(rectInsets,rectInsets,rectInsets,rectInsets), animated: true)
            
            // Start Map Navigation
            self?.startNavigationOnMap()
        }
    }
    
    private func startNavigationOnMap() {
        let status = CLLocationManager.authorizationStatus()
        let locationStatusRestricted = (status  == .denied ||  status  == .restricted)
        let locationServicesEnabled = CLLocationManager.locationServicesEnabled()
        
        if (locationServicesEnabled == false || locationStatusRestricted) {
            showNavigationFailureAlert()
        } else {
            self.locationManager.delegate = self
            self.locationManager.distanceFilter = mapRouteConstants.distanceFilterInMeters
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func showNavigationFailureAlert() {
        let navigationFailedAlert = UIAlertController(title: AlertTitle.navigationFailureError, message: AlertMessage.navigationFailureError, preferredStyle: .alert)
        navigationFailedAlert.addAction(UIAlertAction(title: SnapXButtonTitle.ok, style: .default, handler: nil))
        self.present(navigationFailedAlert, animated: true, completion: nil)
    }
}

extension RestaurantDirectionsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations[0]
        // Remove Earlier Annotations
        for annotation in mapView.annotations {
            if let clAnnotation = annotation as? CurrentLocationAnnotation {
                mapView.removeAnnotation(clAnnotation)
            }
        }
        
        // Add Annotation with updated Location
        let clAnnotation = CurrentLocationAnnotation()
        clAnnotation.coordinate = newLocation.coordinate
        self.mapView.addAnnotation(clAnnotation)
    }
}
