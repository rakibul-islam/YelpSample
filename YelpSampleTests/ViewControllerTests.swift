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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
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
