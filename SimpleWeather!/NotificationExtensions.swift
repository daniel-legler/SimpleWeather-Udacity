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
}

extension UIViewController {
    
    @objc func noConnection() {
        
        let alert = UIAlertController(title: "No Network Connection", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: {
            Loading.shared.hide()
        })
        
    }
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}
