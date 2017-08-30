//
//  NotificationExtension.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/11/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let SWSaveWeatherDone = Notification.Name("SWSaveWeatherDoneNotification")
    static let SWNoNetworkConnection = Notification.Name("SWNoNetworkConnectionNotification")
    static let SWLocationAvailable = Notification.Name("SWLocationAvailableNotification")
}
