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
}
