//
//  ViewControllerTests.swift
//  YelpSampleTests
//
//  Created by Rakibul Islam on 12/18/17.
//  Copyright © 2017 Rakibul Islam. All rights reserved.
//

import XCTest
import CoreLocation
@testable import YelpSample

class ViewControllerTests: XCTestCase {
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.loadView()
    }
    
    func testNumberOfRows_afterViewDidLoad_shouldReturn0() {
        viewController.viewDidLoad()
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 0)
    }
    
    func testSearchButtonClicked_withSearchText_shouldReturnResults() {
        let mockServices = MockYelpServices()
        mockServices.success = true
        mockServices.serviceSuccess = true
        viewController.yelpServices = mockServices
        let locationManager = MockCLLocationManager()
        locationManager.mockLocation = CLLocation(latitude: 15.250, longitude: 15.250)
        viewController.locationManager = locationManager
        let searchBar = viewController.searchBar
        searchBar?.text = "Cuisine"
        viewController.searchBarSearchButtonClicked(searchBar!)
        XCTAssertEqual(viewController.restaurants.count, 4)
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 4)
    }
    
    func testSearchButtonClicked_withoutSearchText_shouldNotReturnResults() {
        viewController.searchBarSearchButtonClicked(viewController.searchBar!)
        XCTAssertEqual(viewController.restaurants.count, 0)
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 0)
    }
    
    class MockCLLocationManager: CLLocationManager {
        var mockLocation: CLLocation!
        
        override var location: CLLocation? {
            return mockLocation
        }
    }
    
    class MockYelpServices: YelpServicesProtocol {
        var success = false
        var serviceSuccess = false
        
        func searchYelpFor(term: String, location: CLLocation?, successBlock: @escaping ([Restaurant]) -> Void, failureBlock: @escaping (Error) -> Void) {
            if success {
                if serviceSuccess {
                    var restaurants = [Restaurant]()
                    let restaurantNames = [["name": "Restaurant 1"],
                                           ["name": "Restaurant 2"],
                                           ["name": "Restaurant 3"],
                                           ["name": "Restaurant 4"]]
                    for restaurantName in restaurantNames {
                        if let restaurant = Restaurant(dict: restaurantName) {
                            restaurant.address = "Some Address"
                            restaurant.cityStateZip = "City, ST ZipCd"
                            restaurants.append(restaurant)
                        }
                    }
                    successBlock(restaurants)
                } else {
                    let error = NSError(domain: "Service Error", code: 404, userInfo: [NSLocalizedDescriptionKey: "The service bombed!"])
                    failureBlock(error)
                }
            } else {
                let error = NSError(domain: "Error", code: 500, userInfo: [NSLocalizedDescriptionKey: "Something bad happened!"])
                failureBlock(error)
            }
        }
        
        func loadImageFrom(urlString: String?, completionHandler: @escaping (UIImage?) -> Void) {
            completionHandler(UIImage(named: "anImage"))
        }
        
        
    }
    
}
