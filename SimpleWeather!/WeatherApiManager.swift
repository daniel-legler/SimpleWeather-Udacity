//
//  OpenWeatherManager.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/8/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation

typealias WAM = WeatherApiManager

enum WeatherType: String {
    case Clear = "Clear"
    case Cloudy = "Cloudy"
    case RainLight = "RainLight"
    case PartiallyCloudy = "PartiallyCloudy"
    case RainHeavy = "RainHeavy"
    case Snow = "Snow"
    case Thunderstorm = "Thunderstorm"
    case Unkown = "Unknown"
}

enum WeatherApiResponse {
    case CurrentWeather(CurrentWeather)
    case ForecastWeather(ForecastWeather)
    case Error(WeatherApiError)
}

enum WeatherApiError: String {
    case InvalidCoordinates = "Invalid City"
    case DownloadError = "Error downloading weather"
    case JsonError = "Error parsing downloaded weather data"
}

class WeatherApiManager {
    
    private init() {}
    static let shared = WAM()
    
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
        case 700...781: return nil // "Atmosphere" conditions, not supported
        case 800: return .Clear
        case 800...804: return .Cloudy
        case 900...962: return nil // "Extreme" / "Additional" conditions, not supported
        default: return nil
        
        }
    }
    
    func downloadCurrentWeather(lat: Double, lon: Double, completion: @escaping (WeatherApiResponse)->() ) {

        guard let url = currentWeatherUrl(lat, lon) else {
            completion(.Error(.InvalidCoordinates))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            guard error == nil else { completion(.Error(.DownloadError)); return }
            
            var parsedData = [String: Any]()
            do {
                try parsedData = JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
            } catch {
                print(error.localizedDescription)
                completion(.Error(.JsonError))
                return
            }
            
            let currentWeather = CurrentWeather()
            
            // JSON Parsing to get current weather type
            guard let weather = parsedData["weather"] as? [[String:Any]] else { completion(.Error(.JsonError)); return }
            guard let id = weather[0]["id"] as? Int else { print("weather[0][\"id\"]"); completion(.Error(.JsonError)); return }
            guard let directType = weather[0]["main"] as? String else { print("weather[0][\"main\"]"); completion(.Error(.JsonError)); return }
            currentWeather.type = self.weatherTypeForID(id: id)?.rawValue ?? directType.capitalized
            
            // JSON Parsing to get current temperature
            guard let temperatureInfo = parsedData["main"] as? [String:Any] else { print("parsedData[\"main\"]"); completion(.Error(.JsonError)); return }
            guard let currentTemp = temperatureInfo["temp"] as? Double else { print("temperatureInfo[\"temp\"]"); completion(.Error(.JsonError)); return }
            currentWeather.temperature = currentTemp.KelvinToFarenheit()
            
            completion(.CurrentWeather(currentWeather))
                        
            
        }.resume()
        
    }
    
    func downloadWeatherForecast(lat: Double, lon: Double, completion: @escaping (WeatherApiResponse)->() ) {
        
        guard let url = forecastUrl(lat, lon) else {
            completion(.Error(.InvalidCoordinates))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            guard error == nil else { completion(.Error(.DownloadError)); return }
            
            var parsedData = [String: Any]()
            do {
                try parsedData = JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
            } catch {
                print(error.localizedDescription)
                completion(.Error(.JsonError))
                return
            }
            
            let forecast = ForecastWeather()

            guard let allForecasts = parsedData["list"] as? [[String:Any]] else { completion(.Error(.JsonError)); return }
            
            for item in allForecasts {
                
                // JSON Parsing to get forecast high and low
                guard let temperatureInfo = item["temp"] as? [String:Any] else { print("item[\"temp\"]"); completion(.Error(.JsonError)); return }
                guard let lowTemp = temperatureInfo["min"] as? Double else { print("temperatureInfo[\"min\"]"); completion(.Error(.JsonError)); return }
                guard let highTemp = temperatureInfo["max"] as? Double else { print("temperatureInfo[\"max\"]"); completion(.Error(.JsonError)); return }
                forecast.lowTemp = lowTemp.KelvinToFarenheit()
                forecast.highTemp = highTemp.KelvinToFarenheit()
                
                // JSON Parsing to get forecast weather type
                guard let weather = item["weather"] as? [[String:Any]] else { print("item[\"weather\"]"); completion(.Error(.JsonError)); return }
                guard let id = weather[0]["id"] as? Int else { print("weather[0][\"id\"]"); completion(.Error(.JsonError)); return }
                guard let directType = weather[0]["main"] as? String else { print("weather[0][\"main\"]"); completion(.Error(.JsonError)); return }
                forecast.type = self.weatherTypeForID(id: id)?.rawValue ?? directType.capitalized

                // JSON Parsing to get date of this forecast
                guard let date = item["dt"] as? Double else { print("item[\"dt\"]"); completion(.Error(.JsonError)); return }
                let unix_conv_date = Date(timeIntervalSince1970: date)
                forecast.date = unix_conv_date as NSDate
                
                completion(.ForecastWeather(forecast))
                
            }

            
            }.resume()
    
    }
    
}
