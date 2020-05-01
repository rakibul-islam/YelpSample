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
        var dict: [String : Any?] = ["id": "1",
                                    "name": "Restaurant Name",
                                    "image_url": "www.image.com",
                                    "rating": 4.0,
                                    "price": "$$",
                                    "is_closed": false,
                                    "phone": "+18005551212",
                                    "display_phone": "(800) 555-1212",
                                    "review_count": 20,
                                    "url": "https://www.google.com"]
        dict["location"] = ["address1": "123 Fake Street",
                            "address2": nil,
                            "city": "Springfield",
                            "state": "OR",
                            "country": "US",
                            "zip_code": "93982"
        ]
        dict["coordinates"] = ["latitude": 1.23,
                               "longitude": 1.23]
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let restaurant = try? JSONDecoder().decode(Restaurant.self, from: data) else {
                XCTFail("Restaurant not created!")
                return
        }
        XCTAssertEqual(restaurant.id, "1")
        XCTAssertEqual(restaurant.name, "Restaurant Name")
        XCTAssertEqual(restaurant.photoUrl, "www.image.com")
        XCTAssertEqual(restaurant.rating, 4.0)
        XCTAssertEqual(restaurant.price, "$$")
        XCTAssertFalse(restaurant.isClosed)
        XCTAssertEqual(restaurant.phone, "+18005551212")
        XCTAssertEqual(restaurant.displayPhone, "(800) 555-1212")
        XCTAssertEqual(restaurant.numberOfReviews, 20)
        XCTAssertEqual(restaurant.url, URL(string: "https://www.google.com"))
        XCTAssertEqual(restaurant.address, "123 Fake Street")
        XCTAssertNil(restaurant.address2)
        XCTAssertEqual(restaurant.city, "Springfield")
        XCTAssertEqual(restaurant.state, "OR")
        XCTAssertEqual(restaurant.zipCode, "93982")
        XCTAssertEqual(restaurant.latitude, 1.23)
        XCTAssertEqual(restaurant.longitude, 1.23)
    }
    
    func testInitRestaurant_withTruncatedDictionary_shouldCreateRestaurant() {
        var dict: [String : Any] = ["id": "1",
                                    "name": "Restaurant Name",
                                    "image_url": "www.image.com"]
        dict["location"] = ["display_address": ["123 Fake Street"]]
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let restaurant = try? JSONDecoder().decode(Restaurant.self, from: data) else {
                XCTFail("Restaurant not created!")
                return
        }
        XCTAssertEqual(restaurant.id, "1")
        XCTAssertEqual(restaurant.name, "Restaurant Name")
        XCTAssertEqual(restaurant.photoUrl, "www.image.com")
        XCTAssertEqual(restaurant.rating, 0.0)
        XCTAssertNil(restaurant.price)
        XCTAssertFalse(restaurant.isClosed)
        XCTAssertNil(restaurant.phone)
        XCTAssertNil(restaurant.displayPhone)
        XCTAssertEqual(restaurant.numberOfReviews, 0)
        XCTAssertNil(restaurant.url)
        XCTAssertNil(restaurant.address)
        XCTAssertNil(restaurant.address2)
        XCTAssertNil(restaurant.city)
        XCTAssertNil(restaurant.state)
        XCTAssertNil(restaurant.zipCode)
        XCTAssertNil(restaurant.latitude)
        XCTAssertNil(restaurant.longitude)
    }
    
    func testInitRestaurant_withEmptyDict_shouldReturnNil() {
        let dict = [String : Any]()
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                XCTFail("JSON data not created!")
                return
        }
        
        let restaurant = try? JSONDecoder().decode(Restaurant.self, from: data)
        
        XCTAssertNil(restaurant)
    }
    
    func testInitRestaurant_withoutID_shouldReturnNil() {
        let dict = ["name":"Restaurant Name",
                    "image_url":"www.image.com"]
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                XCTFail("JSON data not created!")
                return
        }
        
        let restaurant = try? JSONDecoder().decode(Restaurant.self, from: data)
        
        XCTAssertNil(restaurant)
    }
    
    func testGetFullAddress_withCityStateZip_shouldReturnAddress() {
        let restaurant = Restaurant()
        restaurant.address = "123 Fake Street"
        restaurant.city = "Springfield"
        restaurant.state = "OR"
        restaurant.zipCode = "93982"
        
        let address = restaurant.fullAddress
        
        XCTAssertEqual(address, "123 Fake Street, Springfield, OR 93982")
    }
    
    func testGetMultilineAddress_withCityStateZip_shouldReturnAddress() {
        let restaurant = Restaurant()
        restaurant.address = "123 Fake Street"
        restaurant.city = "Springfield"
        restaurant.state = "OR"
        restaurant.zipCode = "93982"
        
        let address = restaurant.multilineAddress
        
        XCTAssertEqual(address, "123 Fake Street\nSpringfield, OR 93982")
    }
    
    func testGetGoogleMapsURL_withoutCoordinates_shouldReturnNil() {
        let restaurant = Restaurant()
        
        let url = restaurant.googleMapsURL
        
        XCTAssertNil(url)
    }
    
    func testGetGoogleMapsURL_withNameAndCoordinates_shouldReturnNil() {
        let restaurant = Restaurant()
        restaurant.name = "The Restaurant"
        restaurant.latitude = 1.23
        restaurant.longitude = 4.56
        
        let url = restaurant.googleMapsURL
        
        XCTAssertEqual(url, URL(string: "comgooglemaps://?q=The+Restaurant&center=1.23,4.56"))
    }
    
    func testGetAppleMapsURL_withoutCoordinates_shouldReturnNil() {
        let restaurant = Restaurant()
        
        let url = restaurant.appleMapsURL
        
        XCTAssertNil(url)
    }
    
    func testGetAppleMapsURL_withNameAndCoordinates_shouldReturnNil() {
        let restaurant = Restaurant()
        restaurant.name = "The Restaurant"
        restaurant.latitude = 1.23
        restaurant.longitude = 4.56
        
        let url = restaurant.appleMapsURL
        
        XCTAssertEqual(url, URL(string: "https://maps.apple.com/?q=The+Restaurant&ll=1.23,4.56"))
    }
}
