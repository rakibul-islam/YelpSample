//
//  ViewController.swift
//  YelpSample
//
//  Created by Rakibul Islam on 4/13/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var locationManager: CLLocationManager!
    var businessSearch: BusinessSearch? {
        didSet {
            tableView.reloadData()
            if businessSearch?.businesses.count == 0 {
                let alertController = UIAlertController(title: "Error", message: "No results found!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    lazy var yelpServices: YelpServicesProtocol = YelpServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startMonitoringSignificantLocationChanges()
    }

    //MARK: UITableView data source methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessSearch?.businesses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cellIdentifier")
        
        if let restaurant = businessSearch?.businesses[indexPath.row] {
            cell.textLabel?.text = restaurant.name
            cell.detailTextLabel?.text = restaurant.fullAddress
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "showDetail", sender: cell)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let restaurantViewController = segue.destination as? RestaurantViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let restaurant = businessSearch?.businesses[indexPath.row] {
            restaurantViewController.restaurant = restaurant
        }
    }
    
    //MARK: UISearchBar delegate methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text, !searchText.isEmpty {
            yelpServices.searchYelpFor(term: searchText, location: locationManager.location, successBlock: { (businessSearch) in
                DispatchQueue.main.async { [weak self] in
                    self?.businessSearch = businessSearch
                }
            }, failureBlock: { (error) in
                DispatchQueue.main.async { [weak self] in
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription ?? "An error occured, please try again.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    //MARK: UIBarButton methods
    
    @IBAction func sortButtonClicked(_ sender: AnyObject) {
        businessSearch?.businesses.sort(by: { (a, b) -> Bool in
            return a.name.compare(b.name) == ComparisonResult.orderedAscending
        })
        tableView.reloadData()
    }
}

