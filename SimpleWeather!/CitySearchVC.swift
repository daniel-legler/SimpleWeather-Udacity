//
//  ViewController.swift
//  SimpleWeather!
//
//  Created by Daniel Legler on 8/11/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CitySearchVC: UIViewController {
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleter.delegate = self
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
    }
        
}

extension CitySearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
    }
}

extension CitySearchVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completer.filterType = .locationsOnly
        
        let results = completer.results.filter { (searchCompletion: MKLocalSearchCompletion) -> Bool in
            return searchCompletion.subtitle == "" && searchCompletion.title.contains(",") // Ensures city,state,country format
        }
        
        searchResults = results
        searchResultsTableView.reloadData()
    }
        
}

extension CitySearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error) in
            
            guard error == nil else {
                return
            }
            
            let coordinate = response!.mapItems[0].placemark.coordinate
            let city = completion.title.components(separatedBy: ",")[0]
            
            Library.shared.downloadNewWeather(city: city, coordinate: coordinate)
            
            self.performSegue(withIdentifier: "NewCity", sender: self)
        }
    }
}
