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
    var cityStateZip: String?
    var photoUrl: String?
    var latestReview: String?
    var ratingImageUrl: String?
    var latitude: NSNumber?
    var longitude: NSNumber?
    
    init?(dict: [String: Any]) {
        guard !dict.isEmpty, let id = dict["id"] as? String else {
            return nil
        }
        self.id = id
        super.init()
        self.name = dict["name"] as? String ?? ""
        if let location = dict["location"] as? [String: Any] {
            if let displayAddress = location["display_address"] as? [String], displayAddress.count > 1 {
                self.address = displayAddress.first
                self.cityStateZip = displayAddress.last
            }
            if let coordinates = location["coordinates"] as? [String: NSNumber] {
                self.latitude = coordinates["latitude"]
                self.longitude = coordinates["longitude"]
            }
        }
        self.photoUrl = dict["image_url"] as? String
        self.ratingImageUrl = dict["rating_img_url_large"] as? String
        self.latestReview = dict["snippet_text"] as? String
    }
    
    func displayFullAddress() -> String {
        guard let addressString = address else {
            return ""
        }
        guard let secondPart = cityStateZip else {
            return addressString
        }
        return addressString + ", " + secondPart
    }
    
    func displayMultilineAddress() -> String {
        guard let addressString = address else {
            return ""
        }
        guard let secondLine = cityStateZip else {
            return addressString
        }
        return addressString + "\n" + secondLine
    }
    
    func getGoogleMapsURL() -> URL? {
        guard let theLatitude = latitude, let theLongitude = longitude else {
            return nil
        }
        let nameWithPlusSigns = name.replacingOccurrences(of: " ", with: "+")
        return URL(string: "comgooglemaps://?q=\(nameWithPlusSigns)&center=\(theLatitude),\(theLongitude)") ?? nil
    }
    
    func getAppleMapsURL() -> URL? {
        guard let theLatitude = latitude, let theLongitude = longitude else {
            return nil
        }
        let nameWithPlusSigns = name.replacingOccurrences(of: " ", with: "+")
        return URL(string: "http://maps.apple.com/?q=\(nameWithPlusSigns)&ll=\(theLatitude),\(theLongitude)") ?? nil
    }
    
}
