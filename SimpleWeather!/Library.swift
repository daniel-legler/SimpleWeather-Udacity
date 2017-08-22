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
    
    func updateAllWeather(_ completion: (WeatherApiError)->() ) {
        
        if connectedToNetwork() {
            
            let locations = RLM.locations() { error in
                print(error.rawValue)
                return
            }
            
            for loc in locations {
                
                downloadNewWeather(city: loc.city, coordinate: loc.getCoordinate()) { _ in }
                
            }
            
        } else {
            print("No connection")
            NotificationCenter.default.post(name: .SWNoNetworkConnection , object: self, userInfo: nil)
        }
    }
    
    func downloadNewWeather(city: String, coordinate: CLLocationCoordinate2D, completion: @escaping (WeatherApiError)->()) {
        
        WAM.downloadWeather(city: city, lat: coordinate.latitude, lon: coordinate.longitude) { (location, error) in
            
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
