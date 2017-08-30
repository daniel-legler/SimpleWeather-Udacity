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
    @IBOutlet weak var searchActivityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(noConnection), name: .SWNoNetworkConnection , object: nil)
        
        hideKeyboardWhenTappedAround()
        
        searchCompleter.delegate = self

        searchBar.becomeFirstResponder()

    }
    
}

extension CitySearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {

            guard connectedToNetwork() else {
                NotificationCenter.default.post(name: .SWNoNetworkConnection , object: self, userInfo: nil)
                return
            }
        
            searchActivityView.startAnimating()
            searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
        searchResultsTableView.reloadData()
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
        searchActivityView.stopAnimating()
    }
        
}

extension CitySearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count == 0 ? 1 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

        
        guard searchResults.count > 0 else {
            cell.textLabel?.text = "No Search Results"
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        DispatchQueue.global(qos: .background).async {
            search.start { (response, error) in
                
                guard error == nil else {
                    return
                }
                
                let coordinate = response!.mapItems[0].placemark.coordinate
                let city = completion.title.components(separatedBy: ",")[0]
                
                Library.shared.downloadWeather(city: city, coordinate: coordinate, flags: flags(isCurrentLocation: false, isCustomLocation: true), completion: { (error) in
                    print(error.rawValue)
                })
            }
        }
        
        self.performSegue(withIdentifier: "NewCity", sender: self)

    }
}
