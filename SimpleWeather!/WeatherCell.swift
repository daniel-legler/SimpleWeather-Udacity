//
//  WeatherCell.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/10/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var locationSymbol: UIImageView!
    
    weak var location: Location!
    
    func configureWith(_ location: Location) {
        
        self.location = location
        
        self.cityName.text = location.city 
        self.currentTemp.text = "\(String(Int(location.current?.temp ?? 0)))°"
        self.weatherIcon.image = UIImage(named: location.current?.type ?? "Unkown")
        self.locationSymbol.isHidden = !location.isCurrentLocation

        self.customize()
        
        self.deleteButton.customize()

    }
    
    func customize() {
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.masksToBounds = false
        layer.shadowPath = CGPath(rect: self.bounds, transform: nil)
    }
    
}

extension UIButton {
    func customize() {
        self.layer.cornerRadius = 11.0
        self.transform = CGAffineTransform(rotationAngle: CGFloat(.pi / 4.0))
    }
}
    
