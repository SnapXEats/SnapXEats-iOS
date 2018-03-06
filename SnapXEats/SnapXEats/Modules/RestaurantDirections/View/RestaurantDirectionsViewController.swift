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
        
    }
    
    private let meterToMileMultiplier = 0.000621371
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showRestaurantDetails()
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
        addShareButtonOnNavigationItem()
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
        let imageName = (annotation is CurrentLocationAnnotation) ? SnapXEatsImageNames.current_location_marker_icon : SnapXEatsImageNames.marker_icon
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
        
        // Calculate the direction and Show Route
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        calculateDirectionandShowOnMap(sourceMapItem: sourceMapItem, destinationMapItem: destinationMapItem)
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
            let distanceInMiles = response.routes[0].distance*self!.meterToMileMultiplier // Convert meters - miles
            self?.distanceLabel.text = "\(distanceInMiles.rounded(toPlaces: 1)) mi"
            
            let rect = route.polyline.boundingMapRect
            let rectInsets = mapRouteConstants.mapViewVisbileRectInsets
            self?.mapView.setVisibleMapRect(rect, edgePadding:
                UIEdgeInsetsMake(rectInsets,rectInsets,rectInsets,rectInsets), animated: true)
        }
    }
}
