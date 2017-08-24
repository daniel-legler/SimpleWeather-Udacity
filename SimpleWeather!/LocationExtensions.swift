//
//  LocationExtensions.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/10/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation

extension Double {
    func KelvinToFarenheit() -> Double {
        return (self * (9/5) - 459.67).rounded()
    }
}

extension Date {
    func dayOfTheWeek ( ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    func TodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let currentDate = formatter.string(from: self)
        return "Today, \(currentDate)"

    }
}
