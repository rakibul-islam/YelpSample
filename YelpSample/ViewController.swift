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
    var geocoder: CLGeocoder!
    var restaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startMonitoringSignificantLocationChanges()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITableView data source methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier");
        
        let restaurant = restaurants[indexPath.row]
        cell?.textLabel?.text = restaurant.name
        cell?.detailTextLabel?.text = restaurant.displayFullAddress()
        return cell!
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurant" {
            let restaurantViewController = segue.destinationViewController as! RestaurantViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedRestaurant = restaurants[indexPath.row]
            restaurantViewController.restaurant = selectedRestaurant
        }
    }
    
    //MARK: UISearchBar delegate methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let searchText = searchBar.text
        YelpServices.searchYelp(searchText!, location: locationManager.location, completionHandler: { (restaurants) in
            self.restaurants = restaurants
            self.tableView.reloadData()
            if restaurants.count == 0 {
                let alertController = UIAlertController(title: "Error", message: "No results found!", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }
    
    //MARK: UIBarButton methods
    
    @IBAction func sortButtonClicked(sender: AnyObject) {
        restaurants.sortInPlace({ (a, b) -> Bool in
            return a.name.compare(b.name) == NSComparisonResult.OrderedAscending
        })
        self.tableView.reloadData()
    }
}

