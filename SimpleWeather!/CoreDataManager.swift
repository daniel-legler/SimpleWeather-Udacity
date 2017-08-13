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
    
    private var locationEntity: NSEntityDescription {
        
        return NSEntityDescription.entity(forEntityName: "Location", in: context)!

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
        
        deleteLocation(location)
        
        print("Trying to save data for \(location.name!)")
        let locationObject = Location(context: context)
        
        locationObject.latitude = location.lat ?? 0
        locationObject.longitude = location.lon ?? 0
        locationObject.name = location.name ?? "Somewhere"
        
        guard let forecasts = location.forecast else { print("No forecasts in LocationModel"); return }
        
        for forecast in forecasts {
            let forecastObject = ForecastWeather(context: context)
            forecastObject.date = (forecast.date as NSDate?) ?? NSDate()
            forecastObject.highTemp = forecast.highTemp ?? 0
            forecastObject.lowTemp = forecast.lowTemp ?? 0
            forecastObject.type = forecast.type ?? "Unknown"
            forecastObject.location = locationObject
        }
        
        guard let current = location.current else { print("No current weather found in LocationModel"); return }
        let currentWeatherObject = CurrentWeather(context: context)
        currentWeatherObject.temperature = current.temp ?? 0
        currentWeatherObject.type = current.type ?? "Unkown"
        currentWeatherObject.location = locationObject
        
        do {
            try context.save()
            print("Saved Context")
        } catch {
            print(error.localizedDescription)
        }
        
        NotificationCenter.default.post(name: .SWSaveWeatherDone , object: self, userInfo: nil)

    }
    
    // Private Functions
    
    private func deleteLocation(_ location: LocationModel) {
        
        guard let lat = location.lat, let lon = location.lon else {
            print("Nothing Deleted")
            print(location)
            return
        }
        
        print("Looking up items to delete")
        do {
            
            let locationObjects = try context.fetch(Location.fetchRequest()) as! [Location]
            
            for loc in locationObjects {
                if loc.latitude == lat && loc.longitude == lon {
                    print("Found location to delete")
                    context.delete(loc)
                }
            }
            
        } catch {
            
            print("Error loading locations: \(error.localizedDescription)")
        }
    }
    
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
