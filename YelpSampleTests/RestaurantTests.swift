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
        var dict: [String : Any] = ["name":"Restaurant Name",
                    "image_url":"www.image.com",
                    "rating_img_url_large":"www.starimage.com",
                    "snippet_text": "Snippet"]
        dict["location"] = ["display_address": ["123 Fake Street","Springfield, OR 93982"]]
        guard let restaurant = Restaurant(dict: dict) else {
            XCTFail("Restaurant not created!")
            return
        }
        XCTAssertEqual(restaurant.name, "Restaurant Name")
        XCTAssertEqual(restaurant.address, "123 Fake Street")
        XCTAssertEqual(restaurant.cityStateZip, "Springfield, OR 93982")
        XCTAssertEqual(restaurant.photoUrl, "www.image.com")
        XCTAssertEqual(restaurant.ratingImageUrl, "www.starimage.com")
        XCTAssertEqual(restaurant.latestReview, "Snippet")
    }
    
    func testInitRestaurant_withLongerDictionary_shouldCreateRestaurant() {
        // This is an example of a functional test case.
        var dict: [String : Any] = ["name":"Restaurant Name",
                                    "image_url":"www.image.com",
                                    "rating_img_url_large":"www.starimage.com",
                                    "snippet_text": "Snippet"]
        dict["location"] = ["display_address": ["123 Fake Street","South Springfield","Springfield, OR 93982"]]
        guard let restaurant = Restaurant(dict: dict) else {
            XCTFail("Restaurant not created!")
            return
        }
        XCTAssertEqual(restaurant.name, "Restaurant Name")
        XCTAssertEqual(restaurant.address, "123 Fake Street")
        XCTAssertEqual(restaurant.cityStateZip, "Springfield, OR 93982")
        XCTAssertEqual(restaurant.photoUrl, "www.image.com")
        XCTAssertEqual(restaurant.ratingImageUrl, "www.starimage.com")
        XCTAssertEqual(restaurant.latestReview, "Snippet")
    }
    
    func testInitRestaurant_withDisplayAddressTooSmall_shouldCreateRestaurantWithoutAddress() {
        // This is an example of a functional test case.
        var dict: [String : Any] = ["name":"Restaurant Name",
                                    "image_url":"www.image.com",
                                    "rating_img_url_large":"www.starimage.com",
                                    "snippet_text": "Snippet"]
        dict["location"] = ["display_address": ["123 Fake Street"]]
        guard let restaurant = Restaurant(dict: dict) else {
            XCTFail("Restaurant not created!")
            return
        }
        XCTAssertEqual(restaurant.name, "Restaurant Name")
        XCTAssertNil(restaurant.address)
        XCTAssertNil(restaurant.cityStateZip)
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
    
    func testDisplayFullAddress_withCityStateZip_shouldReturnAddress() {
        var dict: [String : Any] = ["name":"Restaurant Name",
                                    "image_url":"www.image.com",
                                    "rating_img_url_large":"www.starimage.com",
                                    "snippet_text": "Snippet"]
        dict["location"] = ["display_address": ["123 Fake Street","Springfield, OR 93982"]]
        let restaurant = Restaurant(dict: dict)!
        XCTAssertEqual(restaurant.displayFullAddress(), "123 Fake Street, Springfield, OR 93982")
    }
    
    func testDisplayMultilineAddress_withCityStateZip_shouldReturnAddress() {
        var dict: [String : Any] = ["name":"Restaurant Name",
                                    "image_url":"www.image.com",
                                    "rating_img_url_large":"www.starimage.com",
                                    "snippet_text": "Snippet"]
        dict["location"] = ["display_address": ["123 Fake Street","Springfield, OR 93982"]]
        let restaurant = Restaurant(dict: dict)!
        XCTAssertEqual(restaurant.displayMultilineAddress(), "123 Fake Street\nSpringfield, OR 93982")
    }
}
