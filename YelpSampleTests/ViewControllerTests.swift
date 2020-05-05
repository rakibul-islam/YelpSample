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
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            XCTFail("ViewController not found!")
            return
        }
        viewController = vc
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
        XCTAssertFalse(searchBar!.isFirstResponder)
        let countExpectation = expectation(description: "search finished")
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewController.businessSearch?.businesses.count, 4)
            XCTAssertEqual(self.viewController.tableView(self.viewController.tableView, numberOfRowsInSection: 0), 4)
            countExpectation.fulfill()
        }
        wait(for: [countExpectation], timeout: 10)
    }
    
    func testSearchButtonClicked_withoutSearchText_shouldNotReturnResults() {
        viewController.searchBarSearchButtonClicked(viewController.searchBar!)
        XCTAssertFalse(viewController.searchBar!.isFirstResponder)
        XCTAssertNil(viewController.businessSearch)
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 0)
    }
    
    func testSearchButtonClicked_withInputFailure_shouldNotReturnResults() {
        let mockServices = MockYelpServices()
        mockServices.success = false
        viewController.yelpServices = mockServices
        let locationManager = MockCLLocationManager()
        locationManager.mockLocation = CLLocation(latitude: 15.250, longitude: 15.250)
        viewController.locationManager = locationManager
        let searchBar = viewController.searchBar
        searchBar?.text = "Cuisine"
        viewController.searchBarSearchButtonClicked(searchBar!)
        XCTAssertFalse(searchBar!.isFirstResponder)
        XCTAssertNil(viewController.businessSearch)
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 0)
    }
    
    func testSearchButtonClicked_withServiceFailure_shouldNotReturnResults() {
        let mockServices = MockYelpServices()
        mockServices.success = true
        mockServices.serviceSuccess = false
        viewController.yelpServices = mockServices
        let locationManager = MockCLLocationManager()
        locationManager.mockLocation = CLLocation(latitude: 15.250, longitude: 15.250)
        viewController.locationManager = locationManager
        let searchBar = viewController.searchBar
        searchBar?.text = "Cuisine"
        viewController.searchBarSearchButtonClicked(searchBar!)
        XCTAssertFalse(searchBar!.isFirstResponder)
        XCTAssertNil(viewController.businessSearch)
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
        
        func searchYelpFor(term: String, location: CLLocation?, successBlock: @escaping (BusinessSearch) -> Void, failureBlock: @escaping (Error?) -> Void) {
            if success {
                if serviceSuccess {
                    var restaurants = [Restaurant]()
                    for index in 1...4 {
                        let restaurant = Restaurant()
                        restaurant.id = "Restaurant \(index)"
                        restaurant.address = "Some Address"
                        restaurant.city = ""
                        restaurants.append(restaurant)
                    }
                    var businessSearch = BusinessSearch()
                    businessSearch.businesses = restaurants
                    successBlock(businessSearch)
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
