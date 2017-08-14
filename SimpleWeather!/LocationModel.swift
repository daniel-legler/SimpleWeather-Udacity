//
//  LocationModel.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/12/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationModel {
    var name: String?
    var lat: Double?
    var lon: Double?
    
    var current: CurrentWeatherModel?
    var forecast: [ForecastWeatherModel]?
    
    func coordinate() -> CLLocationCoordinate2D? {
        guard lat != nil, lon != nil else { return nil }
        return CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
    }
    
    init(location: Location) {
        self.name = location.name
        self.lat = location.latitude
        self.lon = location.longitude
        
        if let currentWeather = location.currentWeather {
            self.current = CurrentWeatherModel(currentWeather)
        } else { self.current = nil }
        
        if let forecastWeather = location.forecastWeather?.array as? [ForecastWeather] {
            forecast = []
            for object in forecastWeather{
                self.forecast?.append(ForecastWeatherModel(object))
            }
        } else { self.forecast = nil }
    }
    
    init() {
        name = nil
        lat = nil
        lon = nil
        current = nil
        forecast = nil
    }
    
}

struct CurrentWeatherModel {
    var temp: Double?
    var type: String?
    
    init(_ currentWeather: CurrentWeather) {
        temp = currentWeather.temperature
        
        if let weatherType = currentWeather.type {
            type = weatherType
        } else { type = nil }
    }
    
    init() {
        temp = nil
        type = nil
    }
}

struct ForecastWeatherModel {
    var highTemp: Double?
    var lowTemp: Double?
    var type: String?
    var date: Date?
    
    init(_ forecastWeather: ForecastWeather) {
        
        highTemp = forecastWeather.highTemp
        lowTemp = forecastWeather.lowTemp
        
        if let weatherType = forecastWeather.type {
            type = weatherType
        } else { type = nil }
        
        if let forecastDate = forecastWeather.date {
            date = forecastDate as Date
        } else { date = nil }
    }
    
    init() {
        highTemp = nil
        lowTemp = nil
        type = nil
        date = nil
    }
    
    
}
