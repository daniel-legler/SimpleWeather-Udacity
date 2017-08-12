//
//  CoreLocationManager.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/8/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation
import CoreLocation

typealias LM = LocationManager

enum CitySearchResponse {
    case Cities([City])
    case Error(Error)
}

struct City {
    var coordinate: CLLocationCoordinate2D
    var name: String
}

class LocationManager {
    
    private init() {}
    static let shared = LM()
    
    
    var locationAuthorizationStatus: Bool = false
    
    func getLocationAuthorization() {
        
    }
    
    func searchForCity(addressString: String, completion: @escaping(CitySearchResponse) -> () ) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            
            guard error == nil, placemarks != nil else {
                completion(.Error(error!))
                return
            }
            
            var cities = [City]()
            for placemark in placemarks! {
                
                let name = placemark.name!
                let coord = placemark.location!.coordinate
                cities.append(City(coordinate: coord, name: name))
            }
            
        }
    }

    
}
