//
//  MapScreen.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Kevin Chen on 12/5/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var eventLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupMapView()
        setupLocationManager()

        // Add event pin if eventLocation is available
        if let eventLocation = eventLocation {
            addEventPin(at: eventLocation)
        }
    }

    private func setupMapView() {
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        showUserAndEventLocation(userLocation: userLocation.coordinate)
    }

    private func addEventPin(at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Event Location"
        mapView.addAnnotation(annotation)
    }

    private func showUserAndEventLocation(userLocation: CLLocationCoordinate2D) {
        // Add user location pin
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = userLocation
        userAnnotation.title = "Your Location"
        mapView.addAnnotation(userAnnotation)

        if let eventLocation = eventLocation {
            // Create a region that includes both the user and event
            let center = CLLocationCoordinate2D(
                latitude: (userLocation.latitude + eventLocation.latitude) / 2,
                longitude: (userLocation.longitude + eventLocation.longitude) / 2
            )

            let latDelta = abs(userLocation.latitude - eventLocation.latitude) * 2.5
            let lonDelta = abs(userLocation.longitude - eventLocation.longitude) * 2.5
            let region = MKCoordinateRegion(
                center: center,
                span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            )

            mapView.setRegion(region, animated: true)
        } else {
            // Fallback: Show user location only
            let region = MKCoordinateRegion(
                center: userLocation,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            mapView.setRegion(region, animated: true)
        }
    }
}
