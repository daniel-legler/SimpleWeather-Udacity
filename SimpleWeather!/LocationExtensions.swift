//
//  LocationExtensions.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/10/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation
import CoreLocation

extension Location {
    func getCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    func setCoordinate(coord: CLLocationCoordinate2D) {
        self.latitude = coord.latitude
        self.longitude = coord.longitude
    }
    
}

extension Double {
    func KelvinToFarenheit() -> Double {
        return (self * (9/5) - 459.67).rounded()
    }
}
