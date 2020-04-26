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
    func searchYelpFor(term: String, location: CLLocation?, successBlock: @escaping ([Restaurant]) -> Void, failureBlock: @escaping (Error?) -> Void)
    func loadImageFrom(urlString: String?, completionHandler: @escaping (UIImage?) -> Void)
}

class YelpServices: YelpServicesProtocol {
    let clientID = "G9jGPw1hizyBZ0ycfHzWiw"
    let apiKey = "lVBlFivyqvkVCUWPul1aLdeI7bcBgLefC1wgKGQQ4Gs1gAxHBNbUF3cuTg1qbuO5zJLDpSYHYyFu2RJqql1PoNE3HIFI4c-baYEfB6luMRN3IMe-UEqtP81stq-lXnYx"
    
    private func getComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.yelp.com"
        components.path = "/v3/businesses/search"
        return components
    }
    
    func searchYelpFor(term: String, location: CLLocation?, successBlock: @escaping ([Restaurant]) -> Void, failureBlock: @escaping (Error?) -> Void) {
        let latitude = location?.coordinate.latitude ?? 0.0
        let longitude = location?.coordinate.longitude ?? 0.0
        var components = getComponents()
        components.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)")
        ]
        guard let url = components.url else {
            failureBlock(nil)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            if let error = error {
                failureBlock(error)
                return
            }
            if let data = data {
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let businesses = jsonDict["businesses"] as? [[String: Any]] {
                        var restaurants = [Restaurant]()
                        for business in businesses {
                            if let restaurant = Restaurant(dict: business) {
                                restaurants.append(restaurant)
                            }
                        }
                        successBlock(restaurants)
                    } else {
                        let error = NSError(domain: "JSON", code: 404, userInfo: [NSLocalizedDescriptionKey: "No business found!"])
                        failureBlock(error as Error)
                    }
                }
                catch let jsonError {
                    failureBlock(jsonError)
                }
            }
        }
        task.resume()
    }
    
    func loadImageFrom(urlString: String?, completionHandler: @escaping (UIImage?) -> Void) {
        if let string = urlString, let url = URL(string: string) {
            let session = URLSession.shared
            let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    completionHandler(image)
                }
            })
            sessionTask.resume()
        }
    }
}
