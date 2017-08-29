//
//  LibraryAPI.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/9/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation
import CoreLocation

// This class is the interface between the UI and Realm/Networking classes
// Implementation of the facade design pattern.
class Library {
    
    private init() {}
    static let shared = Library()
    
    private let WAM = WeatherApiManager()
    private let RLM = RealmManager()
    private let CLM = CoreLocationManager()
    
    func locations() -> [Location]? {
        return RLM.locations()
    }
    
    func addLocalWeatherIfAvailable() {
        
        guard CLM.authStatus else {
            return
        }
        
        CLM.findCity(completion: { (city) in
            
            guard   let city = city,
                    let coordinate = self.CLM.coordinate else { return }
            
            self.RLM.updateCurrentLocation(city: city) {
            
                self.downloadNewWeather(city: city, coordinate: coordinate, isCurrentLocation: true, completion: { _ in })
                
            }
        })
        
    }
    
    func updateAllWeather(_ completion: (WeatherApiError)->() ) {
        
        if connectedToNetwork() {
            
            guard let locations = RLM.locations() else { completion(.RealmError); return }
            
            for loc in locations {
                
                if loc.isCurrentLocation { continue }
                
                downloadNewWeather(city: loc.city, coordinate: loc.getCoordinate()) { _ in }
                
            }
            
            addLocalWeatherIfAvailable()
            
        } else {
            print("No connection")
            NotificationCenter.default.post(name: .SWNoNetworkConnection , object: self, userInfo: nil)
        }
    }
    
    func downloadNewWeather(city: String, coordinate: CLLocationCoordinate2D, isCurrentLocation: Bool = false, completion: @escaping (WeatherApiError)->()) {
                
        WAM.downloadWeather(city: city, lat: coordinate.latitude, lon: coordinate.longitude, isCurrentLocation: isCurrentLocation) { (location, error) in
            
            guard error == nil else { completion(error!); return }
            
            guard let location = location else { completion(.RealmError); return }
            
            self.RLM.save(location) { error in completion(error) }
            
        }
        
    }
    
    func deleteWeatherAt(location: Location, completion: @escaping (WeatherApiError)->()) {
        RLM.delete(location) { error in
            completion(error)
        }
    }
    
    
    
    
    
    
}
