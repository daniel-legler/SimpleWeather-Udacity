//
//  CoreLocationManager.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/8/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation
import CoreLocation


class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    // Request location permission
    // Report location authorization status
    // Return coordinate of current location
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    
    let locationManager = CLLocationManager()
    
    var authStatus: Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways,.authorizedWhenInUse:
                return true
            default:
                return false
            }
        } else {
            return false
        }
        
    }
    
    var coordinate: CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    
    func findCity(completion: @escaping (String?)->Void ) {
        
        guard let location = locationManager.location else {
            print("Location Unavailable")
            completion(nil)
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in

            guard let placemark = placemarks?[0],
                  let city      = placemark.addressDictionary!["City"] as? String else {
                    print("Unable to geocode coordinates")
                    completion(nil)
                    return
            }
            
            completion(city)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            NotificationCenter.default.post(name: .SWLocationAvailable, object: nil)
        }
    }

}
