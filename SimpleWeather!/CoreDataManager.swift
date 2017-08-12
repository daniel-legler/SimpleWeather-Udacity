//
//  CoreDataManager.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/8/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation


final class CoreDataManager {
        
    private let ad = (UIApplication.shared.delegate as! AppDelegate)
    
    private var context: NSManagedObjectContext {
        return ad.persistentContainer.viewContext
    }
    
    func getLocations() -> [LocationModel] {
        
        var locations = [LocationModel]()
        var locationObjects = [Location]()
        
        do {
            
            locationObjects = try context.fetch(Location.fetchRequest())
            locations = locationObjects.map({ LocationModel(location: $0) })
            
        } catch {
            
            print("Error loading locations: \(error.localizedDescription)")
        }
        
        return locations
    }
    
    func saveWeatherAt(location: LocationModel) {
        
    }
    
    // Private Functions
    
    private func loadLocation(lat: Double, lon: Double) -> Location? {
        
        do {
            
            let locationObjects = try context.fetch(Location.fetchRequest()) as? [Location]

            let filteredLocations = locationObjects?.filter({ ($0.latitude == lat && $0.longitude == lon) })
            
            guard (filteredLocations?.count)! <= 1 else {
                fatalError("Found more than one location with same coordinates")
            }
            
            return filteredLocations?.first ?? nil
            
        } catch {
            
            print("Error loading locations: \(error.localizedDescription)")
        }

        return nil
        
    }
    
}
