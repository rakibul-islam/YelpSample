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
    func testInitRestaurant_withDictionary_shouldCreateRestaurant() {
        // This is an example of a functional test case.
        var dict: [String : Any?] = ["id": "1",
                                    "name": "Restaurant Name",
                                    "image_url": "www.image.com",
                                    "rating": 4.0,
                                    "price": "$$",
                                    "is_closed": false,
                                    "phone": "+18005551212",
                                    "display_phone": "(800) 555-1212"]
        dict["location"] = ["address1": "123 Fake Street",
                            "address2": nil,
                            "city": "Springfield",
                            "state": "OR",
                            "country": "US",
                            "zip_code": "93982"
        ]
        dict["coordinates"] = ["latitude": NSNumber(value: 1.23),
                               "longitude": NSNumber(value: 1.23)]
        guard let restaurant = Restaurant(dict: dict) else {
            XCTFail("Restaurant not created!")
            return
        }
        XCTAssertEqual(restaurant.name, "Restaurant Name")
        XCTAssertEqual(restaurant.address, "123 Fake Street")
        XCTAssertEqual(restaurant.city, "Springfield")
        XCTAssertEqual(restaurant.state, "OR")
        XCTAssertEqual(restaurant.zipCode, "93982")
        XCTAssertEqual(restaurant.photoUrl, "www.image.com")
        XCTAssertEqual(restaurant.rating, 4.0)
        XCTAssertEqual(restaurant.price, "$$")
        XCTAssertFalse(restaurant.isClosed)
        XCTAssertEqual(restaurant.latitude, NSNumber(value: 1.23))
        XCTAssertEqual(restaurant.longitude, NSNumber(value: 1.23))
    }
    
    func testInitRestaurant_withLongerDictionary_shouldCreateRestaurant() {
        // This is an example of a functional test case.
        var dict: [String : Any] = ["id": "1",
                                    "name":"Restaurant Name",
                                    "image_url":"www.image.com"]
        dict["location"] = ["address1": "123 Fake Street",
                            "address2": nil,
                            "city": "Springfield",
                            "state": "OR",
                            "country": "US",
                            "zip_code": "93982"
        ]
        guard let restaurant = Restaurant(dict: dict) else {
            XCTFail("Restaurant not created!")
            return
        }
        XCTAssertEqual(restaurant.name, "Restaurant Name")
        XCTAssertEqual(restaurant.address, "123 Fake Street")
        XCTAssertEqual(restaurant.city, "Springfield")
        XCTAssertEqual(restaurant.state, "OR")
        XCTAssertEqual(restaurant.zipCode, "93982")
        XCTAssertEqual(restaurant.photoUrl, "www.image.com")
    }
    
    func testInitRestaurant_withDisplayAddressTooSmall_shouldCreateRestaurantWithoutAddress() {
        // This is an example of a functional test case.
        var dict: [String : Any] = ["id": "1",
                                    "name":"Restaurant Name",
                                    "image_url":"www.image.com"]
        dict["location"] = ["display_address": ["123 Fake Street"]]
        guard let restaurant = Restaurant(dict: dict) else {
            XCTFail("Restaurant not created!")
            return
        }
        XCTAssertEqual(restaurant.name, "Restaurant Name")
        XCTAssertNil(restaurant.address)
        XCTAssertEqual(restaurant.photoUrl, "www.image.com")
    }
    
    func testInitRestaurant_withEmptyDict_shouldReturnNil() {
        let dict = [String : Any]()
        XCTAssertNil(Restaurant(dict: dict))
    }
    
    func testInitRestaurant_withoutID_shouldReturnNil() {
        let dict = ["name":"Restaurant Name",
                    "image_url":"www.image.com"]
        XCTAssertNil(Restaurant(dict: dict))
    }
    
    func testDisplayFullAddress_withCityStateZip_shouldReturnAddress() {
        var dict: [String : Any] = ["id": "1",
                                    "name": "Restaurant Name",
                                    "image_url": "www.image.com",
                                    "rating_img_url_large": "www.starimage.com",
                                    "snippet_text": "Snippet"]
        dict["location"] = ["address1": "123 Fake Street",
                            "address2": nil,
                            "city": "Springfield",
                            "state": "OR",
                            "country": "US",
                            "zip_code": "93982"
        ]
        guard let restaurant = Restaurant(dict: dict) else {
            XCTFail("Restaurant object not created!")
            return
        }
        XCTAssertEqual(restaurant.displayFullAddress(), "123 Fake Street, Springfield, OR 93982")
    }
    
    func testDisplayMultilineAddress_withCityStateZip_shouldReturnAddress() {
        var dict: [String : Any] = ["id": "1",
                                    "name": "Restaurant Name",
                                    "image_url": "www.image.com",
                                    "rating_img_url_large": "www.starimage.com",
                                    "snippet_text": "Snippet"]
        dict["location"] = ["address1": "123 Fake Street",
                            "address2": nil,
                            "city": "Springfield",
                            "state": "OR",
                            "country": "US",
                            "zip_code": "93982"
        ]
        guard let restaurant = Restaurant(dict: dict) else {
            XCTFail("Restaurant object not created!")
            return
        }
        XCTAssertEqual(restaurant.displayMultilineAddress(), "123 Fake Street\nSpringfield, OR 93982")
    }
}
