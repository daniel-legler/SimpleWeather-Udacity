//
//  Loading.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/1/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//
import UIKit

class Loading {
    
    static let shared = Loading(frame: UIScreen.main.bounds)
    
    init(frame: CGRect) {
        activity = UIActivityIndicatorView(frame: frame)
    }
    
    private var activity: UIActivityIndicatorView
    
    private let loadingView = UIView(frame: UIScreen.main.bounds)
        
    func show(_ view: UIView) {
        
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.startAnimating()
        
        loadingView.addSubview(activity)
        view.addSubview(loadingView)
        
    }
    
    func hide() {
        Loading.shared.loadingView.removeFromSuperview()
    }
    
    
}
