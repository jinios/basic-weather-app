//
//  ForecastWeather.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 05/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

struct ForecastWeather: Codable {

    private(set) var timeOfLastupdate: Int
    private(set) var detailWeather: DetailWeather
    private(set) var weather: [Weather]
    private(set) var clouds: Clouds?
    private(set) var wind: Wind?
    private(set) var rain: Rain?
    private(set) var snow: Snow?
    private(set) var dateText: String?

    private enum CodingKeys: String, CodingKey {

        case timeOfLastupdate = "dt"
        case detailWeather = "main"
        case weather
        case clouds
        case wind
        case rain
        case snow
        case dateText = "dt_txt"

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        timeOfLastupdate = try container.decode(Int.self, forKey: .timeOfLastupdate)
        detailWeather = try container.decode(DetailWeather.self, forKey: .detailWeather)
        weather = try container.decode([Weather].self, forKey: .weather)
        clouds = try? container.decode(Clouds.self, forKey: .clouds)
        wind = try? container.decode(Wind.self, forKey: .wind)
        rain = try? container.decode(Rain.self, forKey: .rain)
        snow = try? container.decode(Snow.self, forKey: .snow)
        dateText = try? container.decode(String.self, forKey: .dateText)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(timeOfLastupdate, forKey: .timeOfLastupdate)
        try container.encode(detailWeather, forKey: .detailWeather)
        try container.encode(weather, forKey: .weather)
        try? container.encode(clouds, forKey: .clouds)
        try? container.encode(wind, forKey: .wind)
        try? container.encode(rain, forKey: .rain)
        try? container.encode(snow, forKey: .snow)
        try? container.encode(dateText, forKey: .dateText)
    }

}

