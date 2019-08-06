//
//  LocationTracker.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 05/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import CoreLocation

protocol LocationTrackingDelegate: class {
    func currentLocation(_ location: LocationItem?)
}

class LocationTracker: NSObject, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager?
    weak var locationTrackingdelegate: LocationTrackingDelegate?

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
    }

    func getLocation() {
        let authorizationStatus = CLLocationManager.authorizationStatus()

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager?.delegate = self
            locationManager?.startUpdatingLocation()
        default: return
        }
    }

    func convertLocationItem(location: CLLocation, handler: @escaping ((LocationItem?) -> Void)) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in

            let cityName = placemarks?.last?.locality
            let locationItem = LocationItem(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude,
                                            name: cityName,
                                            isTrackedLocation: true)

            if let error = error as? CLError {
                print(error)
                return
            }
            handler(locationItem)
        }
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            convertLocationItem(location: location) { [weak self] locationItem in
                self?.locationTrackingdelegate?.currentLocation(locationItem) // give Locationitem
            }
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            if error.code == .denied {
                manager.stopUpdatingLocation()
            }
            print(error)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")        // location permission not asked for yet
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")  // location authorized
        case .authorizedAlways:
            print("authorizedAlways")     // location authorized
        case .restricted:
            print("restricted")           // TODO: handle
        case .denied:
            print("denied")               // TODO: handle
        @unknown default: break
        }
    }

}

