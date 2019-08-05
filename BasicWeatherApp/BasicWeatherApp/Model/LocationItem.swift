//
//  LocationItem.swift
//  WeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

enum QueryItemKey: String {
    case latitude = "lat"
    case longitude = "lon"
    case cityId = "id"
    case appid
    case units
    case language = "lang"
}

struct LocationItem {
    var latitude: Double?
    var longitude: Double?
    var name: String?
    var isTrackedLocation: Bool
    
    init(latitude: Double?, longitude: Double, name: String?, isTrackedLocation: Bool = false) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.isTrackedLocation = isTrackedLocation
    }
}

