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
    
    // TODO: Need to prevent current location from overwriting already saved city, and vice versa.
    
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
    
    func updateCurrentLocation(city: String, completion: @escaping ()->() ) {
        
        do {
            
            let realm = try Realm()
            
            // If the current device location already exists in Realm
            if let object = realm.object(ofType: Location.self, forPrimaryKey: city) {
                
                // Update the location object to be the current location
                try realm.write {
                    object.isCurrentLocation = true
                    completion()
                }
                
            } else {
                
                // Otherwise, we need to remove the Location that Realm has saved as the current device location
                self.removeCurrentLocation {
                    completion()
                }
            }
            
        } catch {
            print(error.localizedDescription)
            completion()
        }
        
    }
    
    
    func removeCurrentLocation(completion: @escaping ()->()) {
        
        do {
            
            let realm = try Realm()
            
            let locations = Array(realm.objects(Location.self).filter("isCurrentLocation == true"))
            
            guard let currentLocation = locations.first else { completion(); return }
            
            delete(currentLocation, { _ in })
            
            completion()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
