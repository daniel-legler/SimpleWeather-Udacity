//
//  WeatherTableViewCell.swift
//  WeatherAppV3
//
//  Created by Daniel Legler on 3/4/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var weatherType: UILabel!
    
    @IBOutlet weak var highTemp: UILabel!
    
    @IBOutlet weak var lowTemp: UILabel!
    
    func configureCell(forecast: ForecastWeatherModel) {
        lowTemp.text = "\(String(Int(forecast.lowTemp ?? 0)))°"
        highTemp.text = "\(String(Int(forecast.highTemp ?? 0)))°"
        weatherType.text = forecast.type ?? "Unkown"
        dayLabel.text = forecast.date?.dayOfTheWeek() ?? ""
        weatherIcon.image = UIImage(named: (forecast.type ?? "Unknown"))
    }
   
}
