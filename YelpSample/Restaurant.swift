//
//  Restaurant.swift
//  YelpSample
//
//  Created by Rakibul Islam on 4/13/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import Foundation

class Restaurant: NSObject {
    
    var name: String!
    var address: String?
    var cityStateZip: String?
    var photoUrl: String?
    var latestReview: String?
    var ratingImageUrl: String?
    
    init?(dict: [String: Any]) {
        guard !dict.isEmpty, let name = dict["name"] as? String else {
            return nil
        }
        super.init()
        self.name = name
        if let location = dict["location"] as? [String: Any], let displayAddress = location["display_address"] as? [String], displayAddress.count > 1 {
            self.address = displayAddress.first
            self.cityStateZip = displayAddress.last
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
    
}
