//
//  CurrentWeather.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 05/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {

    static func == (lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
        return lhs.cityID == rhs.cityID
    }

    private(set) var geoPoint: GeoPoint?
    private(set) var weather: [Weather]
    private(set) var detailWeather: DetailWeather
    private(set) var wind: Wind?
    private(set) var clouds: Clouds?
    private(set) var rain: Rain?
    private(set) var snow: Snow?
    private(set) var cityName: String?
    private(set) var cityID: Int?
    private var timeOfLastupdate: TimeInterval?
    private(set) var system: System?
    private(set) var visibility: Int?

    private(set) var dateText: String?
    private var cod: Int?

    private enum CodingKeys: String, CodingKey {
        case geoPoint = "coord"
        case weather = "weather"
        case detailWeather = "main"
        case wind
        case clouds
        case rain
        case snow
        case cityName = "name"
        case cityIdentifier = "id"
        case timeOfLastupdate = "dt"
        case system = "sys"
        case visibility

        case dateText = "dt_txt"
        case cod
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        geoPoint = try container.decode(GeoPoint.self, forKey: .geoPoint)

        weather = try container.decode([Weather].self, forKey: .weather)
        detailWeather = try container.decode(DetailWeather.self, forKey: .detailWeather)
        wind = try? container.decode(Wind.self, forKey: .wind)
        clouds = try? container.decode(Clouds.self, forKey: .clouds)
        rain = try? container.decode(Rain.self, forKey: .rain)
        snow = try? container.decode(Snow.self, forKey: .snow)
        cityName = try? container.decode(String.self, forKey: .cityName)
        cityID = try? container.decode(Int.self, forKey: .cityIdentifier)
        timeOfLastupdate = try? container.decode(TimeInterval.self, forKey: .timeOfLastupdate)
        system = try? container.decode(System.self, forKey: .system)
        visibility = try? container.decode(Int.self, forKey: .visibility)

        dateText = try? container.decode(String.self, forKey: .dateText)
        cod = try? container.decode(Int.self, forKey: .cod)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(geoPoint, forKey: .geoPoint)
        try container.encode(weather, forKey: .weather)
        try container.encode(detailWeather, forKey: .detailWeather)
        try? container.encode(wind, forKey: .wind)
        try? container.encode(clouds, forKey: .clouds)
        try? container.encode(rain, forKey: .rain)
        try? container.encode(snow, forKey: .snow)
        try? container.encode(cityName, forKey: .cityName)
        try? container.encode(cityID, forKey: .cityIdentifier)
        try? container.encode(timeOfLastupdate, forKey: .timeOfLastupdate)
        try? container.encode(system, forKey: .system)
        try? container.encode(visibility, forKey: .visibility)

        try? container.encode(dateText, forKey: .dateText)
        try? container.encode(cod, forKey: .cod)
    }

}
