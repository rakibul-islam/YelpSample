//
//  Restaurant.swift
//  YelpSample
//
//  Created by Rakibul Islam on 4/13/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import Foundation

class Restaurant: NSObject, Decodable {
    var id: String
    var name: String!
    var address: String?
    var address2: String?
    var city: String?
    var state: String?
    var zipCode: String?
    var country: String?
    var photoUrl: String?
    var rating = 0.0
    var latitude: Double?
    var longitude: Double?
    var transactions: [String] = []
    var isClosed: Bool = false
    var displayPhone: String?
    var phone: String?
    var price: String?
    var url: URL?
    var numberOfReviews = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
        case coordinates
        case transactions
        case photoUrl = "image_url"
        case rating
        case price
        case isClosed = "is_closed"
        case phone
        case displayPhone = "display_phone"
        case urlString = "url"
        case numberOfReviews = "review_count"
    }
    
    enum LocationKeys: String, CodingKey {
        case address = "address1"
        case address2
        case city
        case state
        case zipCode = "zip_code"
        case country
    }
    
    enum CoordinateKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    override init() {
        id = UUID().uuidString
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        isClosed = try container.decodeIfPresent(Bool.self, forKey: .isClosed) ?? false
        numberOfReviews = try container.decodeIfPresent(Int.self, forKey: .numberOfReviews) ?? 0
        rating = try container.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
        price = try container.decodeIfPresent(String.self, forKey: .price)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        displayPhone = try container.decodeIfPresent(String.self, forKey: .displayPhone)
        if let urlString = try container.decodeIfPresent(String.self, forKey: .urlString) {
            url = URL(string: urlString)
        }
        
        if let locationContainer = try? container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location) {
            address = try locationContainer.decodeIfPresent(String.self, forKey: .address)
            address2 = try locationContainer.decodeIfPresent(String.self, forKey: .address2)
            city = try locationContainer.decodeIfPresent(String.self, forKey: .city)
            state = try locationContainer.decodeIfPresent(String.self, forKey: .state)
            zipCode = try locationContainer.decodeIfPresent(String.self, forKey: .zipCode)
            country = try locationContainer.decodeIfPresent(String.self, forKey: .country)
        }
        
        if let coordinatesContainer = try? container.nestedContainer(keyedBy: CoordinateKeys.self, forKey: .coordinates) {
            latitude = try coordinatesContainer.decodeIfPresent(Double.self, forKey: .latitude)
            longitude = try coordinatesContainer.decodeIfPresent(Double.self, forKey: .longitude)
        }
    }
    
    lazy var nameWithPlusSigns: String = {
        let nameWithPlusSigns = name.replacingOccurrences(of: " ", with: "+")
        return nameWithPlusSigns
    }()
    
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
