//
//  RealmManager.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/15/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import CoreData
import UIKit
import CoreLocation
import RealmSwift


final class RealmManager {
        
    var currentCity: String? {
        
        do {
            
            let realm = try Realm()
            
            return Array(realm.objects(Location.self).filter("isCurrentLocation == true")).first?.city ?? nil
            
        } catch {
            print(error.localizedDescription)
            return nil
        }

    }
    
    func save(_ location: Location, completion: @escaping (WeatherApiError)->() ) {
    
        do {
            
            let realm = try Realm()
            
            let update: Bool = realm.object(ofType: Location.self, forPrimaryKey: location.city) != nil ? true : false
            
            try realm.write {
                realm.add(location, update: update)
            }
            
        } catch {
            completion(.RealmError); print(error.localizedDescription)
        }
    }
    
    
    func delete(_ location: Location, _ completion: (WeatherApiError)->()) {
        
        do {
            
            let realm = try Realm()
            
            if let object = realm.object(ofType: Location.self, forPrimaryKey: location.city) {
                
                try realm.write {
                    realm.delete(object)
                }
            }
            
        } catch {
            completion(.RealmError); print(error.localizedDescription)
        }

    }
    
    func locations() -> [Location]? {
        
        do {
            
            let realm = try Realm()
            
            let locations = Array(realm.objects(Location.self))
            
            return locations
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func updateCurrentLocation(city: String, completion: @escaping (Bool)->() ) {
        
        do {
            
            let realm = try Realm()
            
            // If there is a current location in Realm already, update or delete it
            if let currentLocation = Array(realm.objects(Location.self).filter("isCurrentLocation == true")).first {
                
                // If this location wasn't added by the user manually, remove it
                if currentLocation.isCustomLocation == false {
                
                    try realm.write {
                        realm.delete(currentLocation)
                    }
                }
                
                // Otherwise, flag it as not the current location
                else {
                    try realm.write {
                        currentLocation.isCurrentLocation = false
                    }
                }
            }
            
            // If the current device location already exists in Realm
            if let object = realm.object(ofType: Location.self, forPrimaryKey: city) {
                
                // Update the location object to be the current location
                try realm.write {
                    object.isCurrentLocation = true
                    completion(true)
                }
                
            } else {
                completion(false)
            }
            
            // Otherwise there is no saved current location, and the current location doesn't exist yet
            
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
        
    }

}
