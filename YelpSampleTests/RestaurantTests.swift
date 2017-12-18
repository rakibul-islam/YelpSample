//
//  RestaurantTests.swift
//  YelpSampleTests
//
//  Created by Rakibul Islam on 12/17/17.
//  Copyright © 2017 Rakibul Islam. All rights reserved.
//

import XCTest
@testable import YelpSample

class RestaurantTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitRestaurant_withDictionary_shouldCreateRestaurant() {
        // This is an example of a functional test case.
        let dict = ["name":"Restaurant Name",
                    "image_url":"www.image.com",
                    "rating_img_url_large":"www.starimage.com",
                    "snippet_text": "Snippet"]
        guard let restaurant = Restaurant(dict: dict) else {
            XCTFail("Restaurant not created!")
            return
        }
        XCTAssertEqual(restaurant.name, "Restaurant Name")
        XCTAssertEqual(restaurant.photoUrl, "www.image.com")
        XCTAssertEqual(restaurant.ratingImageUrl, "www.starimage.com")
        XCTAssertEqual(restaurant.latestReview, "Snippet")
    }
    
    func testInitRestaurant_withEmptyDict_shouldReturnNil() {
        let dict = [String : Any]()
        XCTAssertNil(Restaurant(dict: dict))
    }
    
    func testInitRestaurant_withoutName_shouldReturnNil() {
        let dict = ["image_url":"www.image.com",
                    "rating_img_url_large":"www.starimage.com",
                    "snippet_text": "Snippet"]
        XCTAssertNil(Restaurant(dict: dict))
    }
}
