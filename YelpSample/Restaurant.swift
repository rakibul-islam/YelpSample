//
//  Restaurant.swift
//  YelpSample
//
//  Created by Rakibul Islam on 4/13/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import Foundation

class Restaurant: NSObject {
    var id: String
    var name: String!
    var address: String?
    var address2: String?
    var city: String?
    var state: String?
    var zipCode: String?
    var country: String?
    var photoUrl: String?
    var rating: Double?
    var latitude: NSNumber?
    var longitude: NSNumber?
    var transactions: [String] = []
    var isClosed: Bool = false
    var displayPhone: String?
    var phone: String?
    var price: String?
    
    lazy var nameWithPlusSigns: String = {
        let nameWithPlusSigns = name.replacingOccurrences(of: " ", with: "+")
        return nameWithPlusSigns
    }()
    
    init?(dict: [String: Any?]) {
        guard !dict.isEmpty, let id = dict["id"] as? String else {
            return nil
        }
        self.id = id
        super.init()
        self.name = dict["name"] as? String ?? ""
        if let location = dict["location"] as? [String: Any] {
            if let address1 = location["address1"] as? String {
                self.address = address1
            }
            if let address2 = location["address2"] as? String {
                self.address2 = address2
            }
            if let city = location["city"] as? String {
                self.city = city
            }
            if let state = location["state"] as? String {
                self.state = state
            }
            if let zip = location["zip_code"] as? String {
                self.zipCode = zip
            }
            if let country = location["country"] as? String {
                self.country = country
            }
        }
        if let coordinates = dict["coordinates"] as? [String: NSNumber] {
            self.latitude = coordinates["latitude"]
            self.longitude = coordinates["longitude"]
        }
        self.transactions = dict["transactions"] as? [String] ?? []
        self.photoUrl = dict["image_url"] as? String
        self.rating = dict["rating"] as? Double
        self.price = dict["price"] as? String
        self.isClosed = dict["is_closed"] as? Bool ?? false
        self.phone = dict["phone"] as? String
        self.displayPhone = dict["display_phone"] as? String
    }
    
    func displayFullAddress() -> String {
        guard let addressString = address else {
            return ""
        }
        guard let city = city,
            let state = state,
            let zip = zipCode else {
                return addressString
        }
        return addressString + ", " + city + ", " + state + " " + zip
    }
    
    func displayMultilineAddress() -> String {
        guard let addressString = address else {
            return ""
        }
        guard let city = city,
            let state = state,
            let zip = zipCode else {
                return addressString
        }
        return addressString + "\n" + city + ", " + state + " " + zip
    }
    
    func getGoogleMapsURL() -> URL? {
        guard let theLatitude = latitude, let theLongitude = longitude else {
            return nil
        }
        return URL(string: "comgooglemaps://?q=\(nameWithPlusSigns)&center=\(theLatitude),\(theLongitude)") ?? nil
    }
    
    func getAppleMapsURL() -> URL? {
        guard let theLatitude = latitude, let theLongitude = longitude else {
            return nil
        }
        return URL(string: "http://maps.apple.com/?q=\(nameWithPlusSigns)&ll=\(theLatitude),\(theLongitude)") ?? nil
    }
    
}
