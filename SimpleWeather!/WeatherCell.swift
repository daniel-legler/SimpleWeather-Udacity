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
    @IBOutlet weak var cityName: UILabel!
}

extension UICollectionViewCell {
    func customize() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 20.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
    }
}
