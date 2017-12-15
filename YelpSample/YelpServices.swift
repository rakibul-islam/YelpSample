//
//  YelpServices.swift
//  YelpSample
//
//  Created by Rakibul Islam on 4/13/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit
import OAuthSwift
import CoreLocation

class YelpServices: NSObject{
    static let oauth_consumer_key = "4vn9EPpnj2XYrfpr1xjOlg"
    static let oauth_consumer_secret = "R4Dj5TCWNzAddqSOHnvEBvLqBHQ"
    static let oauth_token = "iLmN_54DxqdncbbD8TFROZrIErQKIvGL"
    static let oauth_token_secret = "Mc6MhG7ZI6uIWmubcF2ktuQg8TU"
    
    static func searchYelp(_ searchTerm: String, location: CLLocation?, completionHandler: @escaping ([Restaurant]) -> Void) {
        let oauthswift = OAuthSwiftClient(consumerKey: oauth_consumer_key, consumerSecret: oauth_consumer_secret, oauthToken: oauth_token, oauthTokenSecret: oauth_token_secret, version: .oauth1)
        let urlString = String.init(format: "https://api.yelp.com/v2/search/")
        var parameters = ["term": searchTerm, "limit" : "10"]
        if location != nil {
            parameters.updateValue(String.init(format: "%f,%f", location!.coordinate.latitude, location!.coordinate.longitude), forKey: "ll")
        }
        else {
            parameters.updateValue("San Francisco", forKey: "location")
        }
        _ = oauthswift.get(urlString, parameters: parameters, success: { (response) in
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: Any]
                var restaurants = [Restaurant]()
                let businesses = jsonDict["businesses"] as? [NSDictionary]
                if businesses != nil {
                    for business in businesses! {
                        print(business)
                        let restaurant = Restaurant(dictionary: business)
                        if restaurant != nil {
                            restaurants.append(restaurant!)
                        }
                    }
                }
                completionHandler(restaurants)
            }
            catch let jsonError as NSError {
                print(jsonError)
            }
        }, failure: { (error) in
            print(error)
        })
        
    }
    
    static func loadImageFromUrl(_ imageUrl: String, completionHandler: @escaping (UIImage?) -> Void) {
        let session = URLSession.shared
        let url = URL.init(string: imageUrl)!
        let sessionTask = session.dataTask(with: url, completionHandler:  { (data, response, error) in
            if data != nil {
                let image = UIImage.init(data: data!)
                completionHandler(image)
            }
        })
        sessionTask.resume()
    }

}
