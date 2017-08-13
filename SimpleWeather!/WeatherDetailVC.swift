//
//  WeatherVC.swift
//  WeatherAppV3
//
//  Created by Daniel Legler on 3/2/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var location = LocationModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateMainUI()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location.forecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WeatherTableViewCell {
            if let forecast = location.forecast?[indexPath.row] {
                cell.configureCell(forecast: forecast)
                return cell
            }
        }
        
        return WeatherTableViewCell()
        
    }
    
    func updateMainUI () {
        
        dateLabel.text = Date().TodayString()
        tempLabel.text = "\(Int(location.current?.temp ?? 0.0))°"
        locationLabel.text = location.name ?? "Unkown"
        weatherTypeLabel.text = location.current?.type ?? "Unkown"
        weatherImage.image = UIImage(named: (location.current?.type ?? "Unkown"))
        
    }
}

