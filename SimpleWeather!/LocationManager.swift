//
//  CoreLocationManager.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/8/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation

typealias LM = LocationManager

class LocationManager {
    
    private init() {}
    static let shared = LM()
    
    
    var locationAuthorizationStatus: Bool = false
    
    func getLocationAuthorization() {
        
    }
}
