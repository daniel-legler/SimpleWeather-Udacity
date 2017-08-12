//
//  WeatherCollectionVC.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/10/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit


class WeatherCollectionVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
//    var locations: [Location] = []
    var locations = [LocationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshWeather()

    }

    @IBAction func addCityButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "CitySearch", sender: nil)
    }
    
    @IBAction func newCityAdded(segue: UIStoryboardSegue) {
        Loading.shared.show(view)
    }
    
    func refreshWeather() {
        
        locations = Library.shared.loadStoredWeather()
        
        collectionView.reloadData()
        
        Loading.shared.hide()

    }
    
    
}


extension WeatherCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else {
            return UICollectionViewCell()
        }
        
        cell.cityName.text = locations[indexPath.row].name ?? "Somewhere"
        
        let weatherType = locations[indexPath.row].current?.type ?? "Unkown"
        
        cell.weatherIcon.image = UIImage(named: weatherType)
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 3.0
        let dimension: CGFloat = (UIScreen.main.bounds.width - (2 * space)) / 2.0
        return CGSize(width: dimension, height: dimension + 20)
    }
}









