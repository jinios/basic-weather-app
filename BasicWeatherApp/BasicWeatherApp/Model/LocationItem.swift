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

struct LocationItem: Hashable, Codable {
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

    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case name
        case isTrackedLocation
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try? container.decode(Double.self, forKey: .latitude)
        longitude = try? container.decode(Double.self, forKey: .longitude)
        name = try? container.decode(String.self, forKey: .name)
        isTrackedLocation = try container.decode(Bool.self, forKey: .isTrackedLocation)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(latitude, forKey: .latitude)
        try? container.encode(longitude, forKey: .longitude)
        try? container.encode(latitude, forKey: .latitude)
        try? container.encode(isTrackedLocation, forKey: .isTrackedLocation)
    }

}

