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
    var restaurants = [Restaurant]()
    
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
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
        
        let restaurant = restaurants[indexPath.row]
        cell?.textLabel?.text = restaurant.name
        cell?.detailTextLabel?.text = restaurant.displayFullAddress()
        return cell!
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let restaurantViewController = segue.destination as? RestaurantViewController {
            let indexPath = tableView.indexPathForSelectedRow!
            restaurantViewController.restaurant = restaurants[indexPath.row]
        }
    }
    
    //MARK: UISearchBar delegate methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            yelpServices.searchYelpFor(term: searchText, location: locationManager.location, successBlock: { (restaurants) in
                self.restaurants = restaurants
                self.tableView.reloadData()
                if restaurants.count == 0 {
                    let alertController = UIAlertController(title: "Error", message: "No results found!", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }, failureBlock: { (error) in
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    //MARK: UIBarButton methods
    
    @IBAction func sortButtonClicked(_ sender: AnyObject) {
        restaurants.sort(by: { (a, b) -> Bool in
            return a.name.compare(b.name) == ComparisonResult.orderedAscending
        })
        self.tableView.reloadData()
    }
}

