//
//  FavoriteCity.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 05/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

struct FavoriteCity: Hashable, Codable {

    var location: LocationItem?
    var currentWeather: CurrentWeather?

    func hash(into hasher: inout Hasher) {
        return hasher.combine(currentWeather?.cityID ?? 0)
    }

    init(location: LocationItem, currentWeather: CurrentWeather?) {
        self.location = location
        self.currentWeather = currentWeather
    }

    static func == (lhs: FavoriteCity, rhs: FavoriteCity) -> Bool {
        return lhs.location == rhs.location
    }

    private enum CodingKeys: String, CodingKey {
        case location
        case currentWeather
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        location = try container.decode(LocationItem.self, forKey: .location)
        currentWeather = try container.decode(CurrentWeather.self, forKey: .currentWeather)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: .location)
        try container.encode(currentWeather, forKey: .currentWeather)
    }

}

