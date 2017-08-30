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
final class Library {
    
    // Download new weather for a city
    // Delete weather for a city
    // Update all weather
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(addLocalWeatherIfAvailable) , name: .SWLocationAvailable, object: nil)
    }
    static let shared = Library()
    
    private let WAM = WeatherApiManager()
    private let RLM = RealmManager()
    private let CLM = CoreLocationManager()
    
    func locations() -> [Location]? {
        return RLM.locations()
    }
    
    
    func updateAllWeather(_ completion: (WeatherApiError)->() ) {
        
        if connectedToNetwork() {
            
            addLocalWeatherIfAvailable()
            
            guard let locations = RLM.locations() else { completion(.RealmError); return }

            for loc in locations {
                
                if loc.isCurrentLocation { continue }
                
                downloadWeather(city: loc.city, coordinate: loc.getCoordinate(), flags: flags(isCurrentLocation: false, isCustomLocation: true) ) { _ in }
                
            }
            
        } else {
            print("No connection")
            NotificationCenter.default.post(name: .SWNoNetworkConnection , object: self, userInfo: nil)
        }
    }
    
    func downloadWeather(city: String, coordinate: CLLocationCoordinate2D, flags: flags, completion: @escaping (WeatherApiError)->()) {
        
        WAM.downloadWeather(city: city, lat: coordinate.latitude, lon: coordinate.longitude, flags: flags) { (location, error) in
            
            guard error == nil else { completion(error!); return }
            
            guard let location = location else { completion(.RealmError); return }
            
            self.RLM.save(location) { error in completion(error) }
            
        }
        
    }
    
    // Delete Weather
    
    func deleteWeatherAt(location: Location, completion: @escaping (WeatherApiError)->()) {
        RLM.delete(location) { error in
            completion(error)
        }
    }
    
    // Download weather for current location
    
    @objc fileprivate func addLocalWeatherIfAvailable() {
        
        guard CLM.authStatus else {
            print("Location Auth Status Denied")
            return
        }
        
        CLM.findCity(completion: { (city) in
            
            guard   let city = city,
                let coordinate = self.CLM.coordinate else { return }
            
            self.RLM.updateCurrentLocation(city: city) { wasCustomLocation in
                
                self.downloadWeather(city: city, coordinate: coordinate, flags: flags(isCurrentLocation: true, isCustomLocation: wasCustomLocation), completion: { _ in })
                
            }
        })
        
    }

}
