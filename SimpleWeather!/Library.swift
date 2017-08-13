//
//  LibraryAPI.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/9/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation
import CoreLocation
// This class manages all interactions between the UI and CoreData/Network/CoreLocation classes
// Implementation of the facade design pattern

class Library {
    
    private init() {}
    static let shared = Library()
    
    private let CDM = CoreDataManager()
    private let WAM = WeatherApiManager()

    func loadStoredWeather() -> [LocationModel] {
        return CDM.getLocations()
    }
    
    func updateAllWeather(_ locations: [LocationModel]) {
        
        if connectedToNetwork() {
            for loc in locations {
                guard loc.coordinate() != nil else { print("Coordinate nil"); continue }
                downloadNewWeather(city: loc.name ?? "Unkown", coordinate: loc.coordinate()!)
            }
        } else {
            NotificationCenter.default.post(name: .SWNoNetworkConnection , object: self, userInfo: nil)
        }
    }
    
    func downloadNewWeather(city: String, coordinate: CLLocationCoordinate2D) {
        
        WAM.downloadWeather(lat: coordinate.latitude, lon: coordinate.longitude) { (response: WeatherApiResponse) in
            
            switch response {
                
            case .Location(var location):
                print("Weather Finished Downloading For \(city)")
                location.name = city
                location.lat = coordinate.latitude
                location.lon = coordinate.longitude
                self.CDM.saveWeatherAt(location: location)
                
            case .Error(let error):
                print(error.rawValue)
            default:
                print("Unexpected WeatherAPI Response")
                break
                
                
                
            }
        }
    }
    
    func deleteWeatherAt(location: LocationModel) {
        CDM.deleteLocation(location)
    }
    
    
    
    
    
    
}
