//
//  BusinessSearch.swift
//  YelpSample
//
//  Created by Rakibul Islam on 5/4/20.
//  Copyright © 2020 Rakibul Islam. All rights reserved.
//

import Foundation
import CoreLocation

struct BusinessSearch: Decodable {
    var businesses: [Restaurant]
    var total: Int
    var region: Region?
    
    struct Region: Decodable {
        var center: Location
    }
    
    struct Location: Decodable {
        var longitude: CLLocationDegrees
        var latitude: CLLocationDegrees
    }
    
    init() {
        businesses = []
        total = 0
    }
}
