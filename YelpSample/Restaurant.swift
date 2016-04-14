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
    var address: String!
    var cityStateZip: String?
    var photoUrl: String!
    var latestReview: String!
    var ratingImageUrl: String!
    
    init?(dictionary: NSDictionary) {
        let name = dictionary["name"] as? String
        let location = dictionary["location"] as! NSDictionary
        let displayAddress = location["display_address"] as! [String]
        let address = displayAddress[0]
        let cityStateZip = displayAddress.count >= 3 ? displayAddress[2] : displayAddress[1]
        let photoUrl = dictionary["image_url"] as? String
        let latestReview = dictionary["snippet_text"] as? String
        let ratingImageUrl = dictionary["rating_img_url_large"] as? String
        self.name = name
        self.address = address
        self.cityStateZip = cityStateZip
        self.photoUrl = photoUrl
        self.latestReview = latestReview
        self.ratingImageUrl = ratingImageUrl
        
        super.init()
        
        if dictionary.count == 0 || name == nil {
            return nil
        }
    }
    
    func displayFullAddress() -> String {
        if cityStateZip != nil {
            return address + ", " + cityStateZip!
        }
        return address
    }
    
    func displayMultilineAddress() -> String {
        if cityStateZip != nil {
            return address + "\n" + cityStateZip!
        }
        return address
    }
    
}