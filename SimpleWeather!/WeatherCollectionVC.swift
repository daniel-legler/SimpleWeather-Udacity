//
//  WeatherCollectionVC.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/10/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

let swColor = UIColor(red: 71/255, green: 96/255, blue: 137/255, alpha: 1)
let navigationBarTitleAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)!,
                                    NSForegroundColorAttributeName: swColor]


class WeatherCollectionVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!

    var locations = [LocationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationController?.navigationBar.titleTextAttributes = navigationBarTitleAttributes
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.action = #selector(editButton)
        navigationItem.leftBarButtonItem?.tintColor = swColor
        toolBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWeather), name: .SWSaveWeatherDone , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noConnection), name: .SWNoNetworkConnection , object: nil)

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

        Library.shared.updateAllWeather(locations)

    }
    
    @objc func refreshWeather() {
        
        self.locations = Library.shared.loadStoredWeather()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            Loading.shared.hide()
        }
    }
    
    @objc func noConnection() {
        
        let alert = UIAlertController(title: "No Network Connection", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: {
            Loading.shared.hide()
        })
        
    }
    
    @objc func editButton() {
        setEditing(!isEditing, animated: true)
    }
    
}


extension WeatherCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !isEditing
    }
    
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
        
        let temp = locations[indexPath.row].current?.temp ?? 0
        cell.currentTemp.text = "\(String(Int(temp)))°"

        let weatherType = locations[indexPath.row].current?.type ?? "Unkown"

        cell.weatherIcon.image = UIImage(named: weatherType)
        
        cell.customize()
        
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        collectionView.allowsMultipleSelection = editing
        toolBar.isHidden = !editing
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 3.0
        let dimension: CGFloat = (UIScreen.main.bounds.width - 20 - (2 * space)) / 2.0
        return CGSize(width: dimension, height: dimension + 10)
    }
}









