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

class RestaurantsMapViewViewController: BaseViewController, StoryboardLoadable {

    private let edgeInsetConstant: CGFloat = 15
    
    // MARK: Properties
    @IBOutlet var mapView: MKMapView!
    var presenter: RestaurantsMapViewPresentation?
    var restaurants = [Restaurant]()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showRestaurantsOnMap()
    }
    
    private func showRestaurantsOnMap() {
        var annotations = [MKPointAnnotation]()
        for restaurant in restaurants {
            let restaurantCoordinates = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            let locationPlacemark = MKPlacemark(coordinate: restaurantCoordinates, addressDictionary: nil)
            let locationAnnotation = MKPointAnnotation()
            if let location = locationPlacemark.location {
                locationAnnotation.coordinate = location.coordinate
            }
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
        
        //Show Overlay on Map with Specified Radius
        let distancePreference = LoginUserPreferences.shared.distancePreference
        let radiusInMeters = Int(Double(distancePreference) * 1609.344)
        addOverlayWithLocation(location: currentLocation, radius: CLLocationDistance(radiusInMeters))
        
    }
    
    private func addOverlayWithLocation(location: CLLocationCoordinate2D, radius: CLLocationDistance ) {
        let overlay = MKCircle(center: location, radius: radius)
        mapView.add(overlay)
        
        let height:CGFloat = mapView.frame.width - edgeInsetConstant*2
        let edgeInsetBottom = self.mapView.frame.size.height - edgeInsetConstant - height
        
        self.mapView.setVisibleMapRect(overlay.boundingMapRect, edgePadding:
            UIEdgeInsetsMake(edgeInsetConstant, edgeInsetConstant, edgeInsetBottom,edgeInsetConstant), animated: true)
    }
}

extension RestaurantsMapViewViewController: RestaurantsMapViewView {
    func initView() {
        customizeNavigationItem(title: "Within \(LoginUserPreferences.shared.distancePreference) Miles", isDetailPage: true)
    }
}

extension RestaurantsMapViewViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "")
        let imageName = (annotation is CurrentLocationAnnotation) ? SnapXEatsImageNames.current_location_marker_icon : SnapXEatsImageNames.marker_icon
        annotationView.image = UIImage(named: imageName)
        annotationView.canShowCallout = false
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.rgba(170.0, 170.0, 170.0, 0.3)
        return renderer
    }
}
