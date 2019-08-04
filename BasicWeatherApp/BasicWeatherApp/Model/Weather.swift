//
//  Weather.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

typealias Humidity = Int
typealias Pressure = Float
typealias Temperature = Float


struct GeoPoint: Codable {
    private(set) var longitude: Double
    private(set) var latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
}

struct Weather: Codable {
    
    private(set) var identifier: Int
    private(set) var main: String
    private(set) var description: String
    private(set) var icon: String

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case main
        case description
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        identifier = try container.decode(Int.self, forKey: .identifier)
        main = try container.decode(String.self, forKey: .main)
        description = try container.decode(String.self, forKey: .description)
        icon = try container.decode(String.self, forKey: .icon)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(main, forKey: .main)
        try container.encode(description, forKey: .description)
        try container.encode(icon, forKey: .icon)
    }
}

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

struct Wind: Codable, MiscellaneousDetailWeather {

    var title: String {
        return "바람"
    }

    var value: String {
        return "\(speed.rounded())m/s, \(direction())"
    }

    private(set) var speed: Float
    private(set) var degrees: Float
    
    private enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        speed = try container.decode(Float.self, forKey: .speed)
        degrees = try container.decode(Float.self, forKey: .degrees)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(speed, forKey: .speed)
        try container.encode(degrees, forKey: .degrees)
    }

    private func direction() -> String {
        switch self.degrees.rounded() {
        case 360, 0..<1: return"북풍"
        case 1..<90: return "북동풍"
        case 90..<91: return "동풍"
        case 91..<180: return "남동풍"
        case 180..<181: return "남풍"
        case 181..<270: return "남서풍"
        case 270: return "서풍"
        default: return "북서풍"
        }
    }
}

struct Clouds: Codable, MiscellaneousDetailWeather {
    
    private(set) var all: Int

    var title: String {
        return "구름"
    }

    var value: String {
        return "\(all)%"
    }

    private enum CodingKeys: String, CodingKey {
        case all
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        all = try container.decode(Int.self, forKey: .all)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(all, forKey: .all)
    }
}

struct Rain: Codable, MiscellaneousDetailWeather {

    var title: String {
        return "비"
    }

    var value: String {
        return "\(volume3Hours)mm"
    }

    private(set) var volume1Hours: Float? // volume for the last 1 hours
    private(set) var volume3Hours: Float // volume for the last 3 hours
    
    private enum CodingKeys: String, CodingKey {
        case volumeFor1Hours = "1h"
        case volumeFor3Hours = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        volume1Hours = try? container.decode(Float.self, forKey: .volumeFor1Hours)
        volume3Hours = try container.decode(Float.self, forKey: .volumeFor3Hours)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(volume1Hours, forKey: .volumeFor1Hours)
        try container.encode(volume3Hours, forKey: .volumeFor3Hours)
    }
}

struct Snow: Codable, MiscellaneousDetailWeather {

    var title: String {
        return "눈"
    }

    var value: String {
        return "\(volume3Hours)mm"
    }

    private(set) var volume1Hours: Float? // volume for the last 1 hours
    private(set) var volume3Hours: Float // volume for the last 3 hours

    private enum CodingKeys: String, CodingKey {
        case volumeFor1Hours = "1h"
        case volumeFor3Hours = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        volume1Hours = try? container.decode(Float.self, forKey: .volumeFor1Hours)
        volume3Hours = try container.decode(Float.self, forKey: .volumeFor3Hours)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(volume1Hours, forKey: .volumeFor1Hours)
        try container.encode(volume3Hours, forKey: .volumeFor3Hours)
    }

}


struct System: Codable {
    
    private(set) var type: Int = 0
    private(set) var identifier: Int = 0
    private(set) var message: Double = 0
    private(set) var country: String = ""
    private(set) var sunrise: TimeInterval = 0
    private(set) var sunset: TimeInterval = 0
    
    private enum CodingKeys: String, CodingKey {
        case type
        case identifier = "id"
        case message
        case country
        case sunrise
        case sunset
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try? container.decode(Int.self, forKey: .type)
        let identifier = try? container.decode(Int.self, forKey: .identifier)
        let message = try? container.decode(Double.self, forKey: .message)
        let country = try? container.decode(String.self, forKey: .country)
        let sunrise = try? container.decode(TimeInterval.self, forKey: .sunrise)
        let sunset = try? container.decode(TimeInterval.self, forKey: .sunset)
        
        self.type = type ?? 0
        self.identifier = identifier ?? 0
        self.message = message ?? 0
        self.country = country ?? ""
        self.sunrise = sunrise ?? 0
        self.sunset = sunset ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(type, forKey: .type)
        try? container.encode(identifier, forKey: .identifier)
        try? container.encode(message, forKey: .message)
        try? container.encode(country, forKey: .country)
        try container.encode(sunrise, forKey: .sunrise)
        try container.encode(sunset, forKey: .sunset)
    }

}


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

struct Forecast: Codable {
    private(set) var count: Int
    private(set) var list: [ForecastWeather]
    private(set) var code: String?
    private(set) var message: Double?

    private enum CodingKeys: String, CodingKey {
        case count = "cnt"
        case list
        case code = "cod"
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        count = try container.decode(Int.self, forKey: .count)
        list = try container.decode([ForecastWeather].self, forKey: .list)
        code = try? container.decode(String.self, forKey: .code)
        message = try? container.decode(Double.self, forKey: .message)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(count, forKey: .count)
        try container.encode(list, forKey: .list)
        try? container.encode(code, forKey: .code)
        try? container.encode(message, forKey: .message)
    }

    func weeklyForecast() -> [ForecastWeather] {
        return self.list.filter{ $0.dateText?.hasSuffix("12:00:00") ?? false }
    }
}


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
