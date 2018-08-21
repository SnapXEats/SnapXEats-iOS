//
//  RestaurantsMapViewViewController.swift
//  SnapXEats
//
//  Created by synerzip on 06/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FSPagerView

class RestaurantsMapViewViewController: BaseViewController, StoryboardLoadable {
    
    private let edgeInsetConstant: CGFloat = 15
    private let navigationTitle = "Within %d Miles"
    
    // MARK: Properties
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(UINib(nibName: SnapXEatsNibNames.restaurantCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: SnapXEatsCellResourceIdentifiler.restaurantCollectionView)
        }
    }
    
    var presenter: RestaurantsMapViewPresentation?
    var restaurants = [Restaurant]()
    var annotations = [MKPointAnnotation]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showRestaurantsOnMap()
        setupRestaurantsCarousal()
    }
    
    private func setupRestaurantsCarousal() {
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.reloadData()
    }
    
    private func showRestaurantsOnMap() {
        if self.mapView.annotations.count == 0 { // TO Avod replotting of markers on coming back from next screen
            for restaurant in restaurants {
                let restaurantCoordinates = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
                let locationPlacemark = MKPlacemark(coordinate: restaurantCoordinates, addressDictionary: nil)
                let locationAnnotation = MKPointAnnotation()
                if let location = locationPlacemark.location {
                    locationAnnotation.coordinate = location.coordinate
                }
                locationAnnotation.title = restaurant.restaurant_name
                annotations.append(locationAnnotation)
            }
            
            let currentLocationCoordinates = SelectedPreference.shared.getLatitude()
            let currentLocation = CLLocationCoordinate2D(latitude: Double(truncating: currentLocationCoordinates.0 as NSNumber), longitude: Double(truncating: currentLocationCoordinates.1 as NSNumber))
            
            let currentLocationPlacemark = MKPlacemark(coordinate: currentLocation, addressDictionary: nil)
            let currentLocationAnnotation = CurrentLocationAnnotation()
            if let location = currentLocationPlacemark.location {
                currentLocationAnnotation.coordinate = location.coordinate
            }
            annotations.append(currentLocationAnnotation)
            self.mapView.showAnnotations(annotations, animated: true )
            
            //Show Overlay Circle on Map with Specified Radius
            let distancePreference = LoginUserPreferences.shared.distancePreference
            let radiusInMeters = Int(Double(distancePreference) * SnapXEatsAppDefaults.milesToMetersMultiplier)
            addOverlayWithLocation(location: currentLocation, radius: CLLocationDistance(radiusInMeters))
            
            // Show First Restaurant selected on Map by Default
            self.mapView.selectAnnotation(annotations[0], animated: true)
        }
    }
    
    private func addOverlayWithLocation(location: CLLocationCoordinate2D, radius: CLLocationDistance ) {
        let overlay = MKCircle(center: location, radius: radius)
        mapView.add(overlay)
        
        let height:CGFloat = mapView.frame.width - edgeInsetConstant*2
        let edgeInsetBottom = self.mapView.frame.size.height - edgeInsetConstant - height
        
        self.mapView.setVisibleMapRect(overlay.boundingMapRect, edgePadding:
            UIEdgeInsetsMake(edgeInsetConstant, edgeInsetConstant, edgeInsetBottom,edgeInsetConstant), animated: true)
    }
    
    private func showDistanceForRestaurant(restaurantLocation: CLLocationCoordinate2D, onCell cell:RestaurantCollectionViewCell) {
        let currentLocation = SelectedPreference.shared.getLatitude()
        let sourceLocation = CLLocationCoordinate2D(latitude: Double(truncating: currentLocation.0 as NSNumber), longitude: Double(truncating: currentLocation.1 as NSNumber))
        let destinationLocation = restaurantLocation
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate {(response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error in Finding Routes: \(error)")
                }
                return
            }
            // Show Distance in Miles
            let distanceInMiles = response.routes[0].distance*SnapXEatsAppDefaults.meterToMileMultiplier // Convert meters - miles
            cell.restaurantDistanceLabel.text = String(format:SnapXEatsAppDefaults.restaurantDistance, distanceInMiles)
        }
    }
}

extension RestaurantsMapViewViewController: RestaurantsMapViewView {
    func initView() {
        if LoginUserPreferences.shared.isLoggedIn, let distancePreference = presenter?.getUserPreference(userID: LoginUserPreferences.shared.loginUserID) {
            customizeNavigationItem(title: String(format:navigationTitle, distancePreference.distancePreference), isDetailPage: true)
        } else {
            customizeNavigationItem(title: String(format:navigationTitle, LoginUserPreferences.shared.distancePreference), isDetailPage: true)
        }
    }
}

extension RestaurantsMapViewViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: SnapXEatsAppDefaults.emptyString)
        let imageName = (annotation is CurrentLocationAnnotation) ? SnapXEatsImageNames.current_location_marker_icon : SnapXEatsImageNames.marker_icon
        annotationView.image = UIImage(named: imageName)
        annotationView.canShowCallout = false
        // Avoid changing image of CurrentLocation marker
        annotationView.isEnabled = (annotation is CurrentLocationAnnotation) ? false : true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.rgba(170.0, 170.0, 170.0, 0.3)
        return renderer
    }
    
    // Change image on Selecting particular Annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(named:SnapXEatsImageNames.marker_icon_selected)
    }
    
    // Reset the changed image on deSelecting particular Annotation
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named:SnapXEatsImageNames.marker_icon)
    }
}

extension RestaurantsMapViewViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return restaurants.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: SnapXEatsCellResourceIdentifiler.restaurantCollectionView, at: index) as! RestaurantCollectionViewCell
        
        let restaurant = restaurants[index]
        cell.configureRestaurantCell(restaurant: restaurant)
        if checkRechability() { // Calculate and Show distance between current location and Restaurant
            let restaurantLocation = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            showDistanceForRestaurant(restaurantLocation: restaurantLocation, onCell: cell)
        }
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        // Programatically Select Annotation at dragged Index
        if targetIndex < annotations.count && targetIndex >= 0 {
            mapView.selectAnnotation(annotations[targetIndex], animated: true)
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let restaurant = restaurants[index]
        if let parent = self.navigationController, let restaurantId = restaurant.restaurant_info_id {
            presenter?.gotoRestaurantInfo(selectedRestaurant: restaurantId, parent: parent, showMoreInfo: true)
        }
    }
}
