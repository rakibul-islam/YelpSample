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

protocol YelpServicesProtocol {
    func searchYelpFor(term: String, location: CLLocation?, successBlock: @escaping ([Restaurant]) -> Void, failureBlock: @escaping (Error) -> Void)
    func loadImageFrom(urlString: String?, completionHandler: @escaping (UIImage?) -> Void)
}

class YelpServices: YelpServicesProtocol {
    func searchYelpFor(term: String, location: CLLocation?, successBlock: @escaping ([Restaurant]) -> Void, failureBlock: @escaping (Error) -> Void) {
        let oauthswift = OAuthSwiftClient(consumerKey: oauth_consumer_key, consumerSecret: oauth_consumer_secret, oauthToken: oauth_token, oauthTokenSecret: oauth_token_secret, version: .oauth1)
        let urlString = String.init(format: "https://api.yelp.com/v2/search/")
        var parameters = ["term": term, "limit" : "10"]
        if location != nil {
            parameters.updateValue(String.init(format: "%f,%f", location!.coordinate.latitude, location!.coordinate.longitude), forKey: "ll")
        }
        else {
            parameters.updateValue("San Francisco", forKey: "location")
        }
        _ = oauthswift.get(urlString, parameters: parameters, success: { (response) in
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any], let businesses = jsonDict["businesses"] as? [[String: Any]] {
                    var restaurants = [Restaurant]()
                    for business in businesses {
                        if let restaurant = Restaurant(dict: business) {
                            restaurants.append(restaurant)
                        }
                    }
                    successBlock(restaurants)
                } else {
                    
                }
            }
            catch let jsonError {
                failureBlock(jsonError)
            }
        }, failure: { (error) in
            failureBlock(error)
        })
    }
    
    let oauth_consumer_key = "4vn9EPpnj2XYrfpr1xjOlg"
    let oauth_consumer_secret = "R4Dj5TCWNzAddqSOHnvEBvLqBHQ"
    let oauth_token = "iLmN_54DxqdncbbD8TFROZrIErQKIvGL"
    let oauth_token_secret = "Mc6MhG7ZI6uIWmubcF2ktuQg8TU"
    
    func loadImageFrom(urlString: String?, completionHandler: @escaping (UIImage?) -> Void) {
        if let string = urlString, let url = URL(string: string) {
            let session = URLSession.shared
            let sessionTask = session.dataTask(with: url, completionHandler:  { (data, response, error) in
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    completionHandler(image)
                }
            })
            sessionTask.resume()
        }
    }
}
