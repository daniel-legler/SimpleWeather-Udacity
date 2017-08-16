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
    
    var locationAuthorizationStatus: Bool = false
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocationCoordinate2D? {
        
        return locationManager.location?.coordinate

    }
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}
