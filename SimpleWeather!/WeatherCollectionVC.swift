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
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWeather), name: .SWSaveWeatherDone , object: nil)
        
        refreshWeather()

    }

    @IBAction func addCityButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "CitySearch", sender: nil)
    }
    
    @IBAction func newCityAdded(segue: UIStoryboardSegue) {
        Loading.shared.show(view)
    }
    
    @IBAction func refreshButton(_ sender: Any) {

        Loading.shared.show(view)

        refreshWeather()
    }
    
    @objc func refreshWeather() {
        
        locations = Library.shared.loadStoredWeather()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            Loading.shared.hide()
        }

    }
    
    
}


extension WeatherCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let weatherDetailVC = segue.destination as? WeatherDetailVC {
            guard let tappedCell = collectionView.indexPathsForSelectedItems?.first else { return }
            weatherDetailVC.location = locations[tappedCell.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "WeatherDetail", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else {
            return UICollectionViewCell()
        }
        
        cell.cityName.text = locations[indexPath.row].name ?? "Somewhere"
        
        let weatherType = locations[indexPath.row].current?.type ?? "Unkown"

        cell.weatherIcon.image = UIImage(named: weatherType)
        
//        cell.customize()
        
        return cell
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
        let dimension: CGFloat = (UIScreen.main.bounds.width - 20 - (2 * space)) / 2.0
        return CGSize(width: dimension, height: dimension + 20)
    }
}









