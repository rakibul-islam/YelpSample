//
//  YelpServices.swift
//  YelpSample
//
//  Created by Rakibul Islam on 4/13/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit
import CoreLocation

protocol YelpServicesProtocol {
    func searchYelpFor(term: String, location: CLLocation?, successBlock: @escaping (BusinessSearch) -> Void, failureBlock: @escaping (Error?) -> Void)
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
    
    func searchYelpFor(term: String, location: CLLocation?, successBlock: @escaping (BusinessSearch) -> Void, failureBlock: @escaping (Error?) -> Void) {
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
                    let businessSearch = try JSONDecoder().decode(BusinessSearch.self, from: data)
                    successBlock(businessSearch)
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
