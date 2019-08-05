//
//  DetailWeather.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 05/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

typealias Humidity = Int
typealias Pressure = Float
typealias Temperature = Float

struct DetailWeather: Codable {

    private(set) var temperature: Temperature
    private(set) var minTemperature: Temperature
    private(set) var maxTemperature: Temperature
    private(set) var pressure: Pressure?
    private(set) var seaLevel: Float?
    private(set) var groundLevel: Float?
    private(set) var humidity: Humidity?

    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temperature = try container.decode(Temperature.self, forKey: .temperature)
        minTemperature = try container.decode(Temperature.self, forKey: .minimumTemperature)
        maxTemperature = try container.decode(Temperature.self, forKey: .maximumTemperature)
        pressure = try? container.decode(Float.self, forKey: .pressure)
        seaLevel = try? container.decode(Float.self, forKey: .seaLevel)
        groundLevel = try? container.decode(Float.self, forKey: .groundLevel)
        humidity = try? container.decode(Int.self, forKey: .humidity)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(temperature, forKey: .temperature)
        try container.encode(minTemperature, forKey: .minimumTemperature)
        try container.encode(maxTemperature, forKey: .maximumTemperature)
        try? container.encode(pressure, forKey: .pressure)
        try? container.encode(seaLevel, forKey: .seaLevel)
        try? container.encode(groundLevel, forKey: .groundLevel)
        try? container.encode(humidity, forKey: .humidity)
    }

}

extension Humidity: MiscellaneousDetailWeather {
    var title: String {
        return "습도"
    }

    var value: String {
        return "\(self)%"
    }
}

extension Pressure: MiscellaneousDetailWeather {
    var title: String {
        return "기압"
    }

    var value: String {
        return "\(Int(self.rounded()))hPa"
    }
}

extension Temperature {
    var text: String {
        return "\(Int(self.rounded()))℃"
    }
}
