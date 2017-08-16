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
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addWeatherButton: UIBarButtonItem!
    
    
    var locations = [LocationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationController?.navigationBar.titleTextAttributes = navigationBarTitleAttributes
        navigationController?.navigationBar.tintColor = swColor
        navigationController?.navigationBar.backgroundColor = swColor

        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.action = #selector(editButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWeather), name: .SWSaveWeatherDone , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noConnection), name: .SWNoNetworkConnection , object: nil)

        initializeWeather()
        
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
    
    func initializeWeather() {
       
        locations = Library.shared.loadStoredWeather().sorted(by: { (l1, l2) in
            return l1.name! < l2.name!
        })

        if locations.count > 0 && connectedToNetwork() {
            refreshButton("")
        }
        
    }
    
    @objc func refreshWeather() {
        
        locations = Library.shared.loadStoredWeather().sorted(by: { (l1, l2) in
            return l1.name! < l2.name!
        })
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            Loading.shared.hide()
        }
    }
    
    
    @objc func editButton() {
        setEditing(!isEditing, animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        collectionView.reloadData()
        refreshButton.isEnabled = !editing
        addWeatherButton.isEnabled = !editing
        
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
        if !isEditing {
            performSegue(withIdentifier: "WeatherDetail", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else {
            return UICollectionViewCell()
        }
        
        let temp = locations[indexPath.row].current?.temp ?? 0
        let weatherType = locations[indexPath.row].current?.type ?? "Unkown"

        cell.cityName.text = locations[indexPath.row].name ?? "Somewhere"
        cell.currentTemp.text = "\(String(Int(temp)))°"
        cell.weatherIcon.image = UIImage(named: weatherType)
        cell.customize()
        
        cell.deleteButton.isHidden = !isEditing
        cell.deleteButton.customize()
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteCellButton(button:)), for: UIControlEvents.touchUpInside)
        
        
        return cell
    }
    
    func deleteCellButton(button: UIButton) {
        Library.shared.deleteWeatherAt(location: locations[button.tag])
        locations.remove(at: button.tag)
        collectionView.reloadData()
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









