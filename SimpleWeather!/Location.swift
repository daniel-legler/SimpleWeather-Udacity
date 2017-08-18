//
//  RLocationModel.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/15/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    
    dynamic var city: String = ""
    dynamic var lat: Double = 0.0
    dynamic var lon: Double = 0.0
    
    dynamic var current: CurrentWeather?
    let forecasts = List<ForecastWeather>()
    
    override static func primaryKey() -> String? {
        return "city"
    }
    
}

class CurrentWeather: Object {
    
    dynamic var temp: Double = 0.0
    dynamic var type: String = ""

}

class ForecastWeather: Object {
    
    dynamic var low: Double = 0.0
    dynamic var high: Double = 0.0
    dynamic var type: String = ""
    dynamic var date: Date = Date()

}
