//
//  LocationManager.swift
//  AtlasAgent
//
//  Created by macbook on 20/01/20.
//  Copyright © 2020 relinns. All rights reserved.
//

import UIKit
import CoreLocation
@objc protocol LocationManagerDelegate: class {
    @objc optional func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    @objc optional func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    @objc optional func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    @objc optional func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    @objc optional func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    @objc optional func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
}
class LocationManager: NSObject {
    // MARK: - Variables
    static let sharedInstance = LocationManager()
    private var locationManager: CLLocationManager?
    weak var delegate: LocationManagerDelegate?
    var coordinates: CLLocationCoordinate2D?
    // MARK: - Initializer
    private override init() {
        super.init()
        self.locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
       self.locationManager?.distanceFilter = 50
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.activityType = .automotiveNavigation
    }
    // MARK: - Start Updating Locations
    func startUpdatingLocation() {
        if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||  CLLocationManager.authorizationStatus() == .restricted {
            self.locationManager = CLLocationManager()
            locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
           self.locationManager?.distanceFilter = 50
            self.locationManager?.requestAlwaysAuthorization()
            self.locationManager?.allowsBackgroundLocationUpdates = true
            self.locationManager?.activityType = .automotiveNavigation
            self.locationManager?.requestAlwaysAuthorization()
            self.locationManager?.requestWhenInUseAuthorization()
        } else {
            self.locationManager?.startUpdatingLocation()
            self.locationManager?.startUpdatingHeading()
        }
    }
    // MARK: - Stop Updating Locations
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
    // MARK: - Get Address from lat, long
    /// Get location from gps coordinates
    func getCurrentPlace(latitude: Double, longitude: Double, complition: @escaping (String, String) -> Void ) {
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = latitude
        let lon: Double = longitude
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        var addressString: String = ""
        var postalCode: String = ""
        
        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
            if error != nil {
                Logger.sharedInstance.logMessage(message: "reverse geodcode fail: \(error!.localizedDescription)")
            }
            if  let place = placemarks {
                if place.count > 0 {
                    let locationData = placemarks?.first
                    // Location name
                    if let locationName = locationData?.name {
                        addressString.append(locationName)
                        print(locationName)
                    }
                    // Street address
                    if let street = locationData?.thoroughfare {
                        addressString.append(", \(street)")
                        print(street)
                    }
                    // City
                    if let city = locationData?.locality {
                        addressString.append(", \(city)")
                        print(city)
                    }
                    // State
                    if let state = locationData?.administrativeArea {
                        addressString.append(", \(state)")
                        print(state)
                    }
                    // Zip code
                    if let zipCode = locationData?.postalCode {
                        addressString.append(", \(zipCode)")
                        postalCode = zipCode
                        print(zipCode)
                    }
                    // Country
                    if let country = locationData?.country {
                        addressString.append(", \(country)")
                        print(country)
                    }
                    complition(addressString, postalCode)
                }
            }
        }
    }
}
// MARK: - Location Manger Delegates
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            coordinates = locationManager?.location?.coordinate
            delegate?.locationManager?(manager, didChangeAuthorization: status)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLoc = locationManager?.location else {
                //self.showalertview(messagestring: "PLEASEALLOWLOCATION".localize())
                return
            }
            coordinates = currentLoc.coordinate
            delegate?.locationManager?(manager, didUpdateLocations: locations)
       // locationManager?.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        coordinates = locationManager?.location?.coordinate
//        delegate?.locationManager?(manager, didUpdateHeading: newHeading)
    }
}
