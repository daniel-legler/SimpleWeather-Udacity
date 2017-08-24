//
//  WeatherDetailVC.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 3/2/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

class WeatherDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = Date().TodayString()
        tempLabel.text = "\(Int(location?.current?.temp ?? 0.0))°"
        locationLabel.text = location?.city
        weatherTypeLabel.text = location?.current?.type
        weatherImage.image = UIImage(named: (location?.current?.type ?? "Unkown"))
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location?.forecasts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WeatherTableViewCell,
            let forecast = location?.forecasts[indexPath.row] else {
                return WeatherTableViewCell()
            }
    
        cell.configureCell(forecast: forecast)
    
        return cell
    
    }
}

