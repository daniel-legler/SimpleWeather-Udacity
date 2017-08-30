//
//  OpenWeatherManager.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/8/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation
import RealmSwift

enum WeatherType: String {
    case Clear = "Clear"
    case Cloudy = "Cloudy"
    case RainLight = "Light Rain"
    case PartiallyCloudy = "Partially Cloudy"
    case RainHeavy = "Heavy Rain"
    case Snow = "Snow"
    case Thunderstorm = "Thunderstorm"
    case Unknown = "Unknown"
}

enum WeatherApiError: String {
    case InvalidCoordinates = "Invalid City"
    case DownloadError = "Error Downloading"
    case JsonError = "Unexpected Server Response"
    case RealmError = "Error Saving Weather"
}

typealias flags = (isCurrentLocation: Bool, isCustomLocation: Bool)

class WeatherApiManager {
    
    private func forecastUrl(_ lat: Double, _ lon: Double) -> URL? {
        return URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(lon)&cnt=10&appid=0356f0d8e9865300021b8b2ba08ee811") ?? nil
    }
    
    private func currentWeatherUrl(_ lat: Double, _ lon: Double) -> URL? {
        return URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=0356f0d8e9865300021b8b2ba08ee811") ?? nil
    }
    
    private func weatherTypeForID(id: Int) -> WeatherType? {
        
        switch id {
            
        case 200...232: return .Thunderstorm
        case 300...321: return .RainLight
        case 500...531: return .RainHeavy
        case 600...622: return .Snow
        case 700...781: return .Cloudy
        case 800: return .Clear
        case 800...804: return .Cloudy
        case 900...962: return .Unknown
        default: return nil
        
        }
    }
    
    func downloadWeather(city: String, lat: Double, lon: Double, flags: flags, completion: @escaping(Location?, WeatherApiError?)->()) {
        
        guard let currentURL = currentWeatherUrl(lat, lon),
              let forecastURL = forecastUrl(lat, lon) else {
                
            completion(nil, .InvalidCoordinates)
            return
        }
        
        var currentWeather = CurrentWeather()
        var forecasts = [ForecastWeather]()
        
        let group = DispatchGroup()
        group.enter() // API Call: Current Weather
        group.enter() // API Call: Forecast Weather
        
        
        weatherApiCall(url: currentURL)  {
            guard $0 == nil, let json = $1 else { completion(nil, $0!); return }
            
            guard let current = self.currentWeatherFromJSON(json, completion: { completion(nil, $0); return }) else { completion(nil, .JsonError); return }
                
            currentWeather = current
            
            group.leave()
        }
        
        weatherApiCall(url: forecastURL) {
            guard $0 == nil, let json = $1 else { completion(nil, $0!); return }

            guard let allForecasts = self.forecastsFromJSON(json, completion: { completion(nil, $0); return }) else { completion(nil, .JsonError); return }
            
            forecasts = allForecasts
            
            group.leave()
        }

        // When finished downloading, return the Location via the completion handler
        group.notify(queue: DispatchQueue.global()) {
            
            let location = Location()
            location.city = city
            location.lat = lat
            location.lon = lon
            location.isCurrentLocation = flags.isCurrentLocation
            location.isCustomLocation = flags.isCustomLocation
            location.current = currentWeather
            location.forecasts.append(objectsIn: forecasts)
            
            completion(location, nil)
        }
        
        
        
        
    }
    
    private func weatherApiCall(url: URL, completion: @escaping (WeatherApiError?, [String:Any]?)->()) {
        
        DispatchQueue.global(qos: .background).async {
            
            URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
                
                guard error == nil else { completion(.DownloadError, nil); return }
                
                var parsedData = [String: Any]()
                do {
                    try parsedData = JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                } catch {
                    completion(.JsonError, nil)
                    return
                }
                
                completion(nil, parsedData)
                
            }.resume()
        }
    }
    
    
    private func currentWeatherFromJSON(_ json: [String:Any], completion: @escaping (WeatherApiError)->()) -> CurrentWeather? {

        let currentWeather = CurrentWeather()

        // JSON Parsing to get current weather type
        guard let weather = json["weather"] as? [[String:Any]],
              let id = weather[0]["id"] as? Int,
              let directType = weather[0]["main"] as? String,
              let temperatureInfo = json["main"] as? [String:Any],
              let currentTemp = temperatureInfo["temp"] as? Double else { completion(.JsonError); return nil }
        
        currentWeather.type = self.weatherTypeForID(id: id)?.rawValue ?? directType.capitalized
        currentWeather.temp = currentTemp.KelvinToFarenheit()
        
        return currentWeather
    }
    
    
    private func forecastsFromJSON(_ json: [String:Any], completion: @escaping (WeatherApiError)->()) -> [ForecastWeather]? {
        
        var forecasts = [ForecastWeather]()
        
        guard let allForecasts = json["list"] as? [[String:Any]] else { completion(.JsonError); return nil}
        
        for item in allForecasts {
            
            // JSON Parsing to get forecast high and low
            guard let temperatureInfo   = item["temp"] as? [String:Any],
                  let date              = item["dt"] as? Double,
                  let lowTemp           = temperatureInfo["min"] as? Double,
                  let highTemp          = temperatureInfo["max"] as? Double else { completion(.JsonError); return nil }

            // JSON Parsing to get forecast weather type
            guard let weather = item["weather"] as? [[String:Any]],
                  let id = weather[0]["id"] as? Int,
                  let directType = weather[0]["main"] as? String else { completion(.JsonError); return nil }
            
            let forecast = ForecastWeather()
            forecast.low = lowTemp.KelvinToFarenheit()
            forecast.high = highTemp.KelvinToFarenheit()
            forecast.type = self.weatherTypeForID(id: id)?.rawValue ?? directType.capitalized
            forecast.date = Date(timeIntervalSince1970: date)
            forecasts.append(forecast)
            
        }
        
        return forecasts
        
    }
}
