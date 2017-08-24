//
//  ViewControllerExtensions.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/23/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @objc func noConnection() {
        
        alert(title: "No Network Connection", message: "")
        
    }
    
    func alert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
    
    func customizeNavigationController() {
        
        navigationController?.navigationBar.titleTextAttributes = navigationBarTitleAttributes
        navigationController?.navigationBar.tintColor = swColor
        navigationController?.navigationBar.backgroundColor = swColor
        
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    
}
