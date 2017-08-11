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

typealias CDM = CoreDataManager

final class CoreDataManager {
    
    private init() {}
    static let shared = CDM()
    
    private let ad = (UIApplication.shared.delegate as! AppDelegate)
    
    private var context: NSManagedObjectContext {
        return ad.persistentContainer.viewContext
    }
    
    func getLocations() -> [Location] {
        return []
    }
    
    func saveCurrentWeather() {
        
    }
    
}
