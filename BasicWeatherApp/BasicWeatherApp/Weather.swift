//
//  Weather.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

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
    
    private(set) var temperature: Float
    private(set) var minTemperature: Float
    private(set) var maxTemperature: Float
    private(set) var pressure: Float?
    private(set) var seaLevel: Float?
    private(set) var groundLevel: Float?
    private(set) var humidity: Int?
    
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
        temperature = try container.decode(Float.self, forKey: .temperature)
        minTemperature = try container.decode(Float.self, forKey: .minimumTemperature)
        maxTemperature = try container.decode(Float.self, forKey: .maximumTemperature)
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

struct Wind: Codable {
    
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
}

struct Clouds: Codable {
    
    private(set) var all: Int
    
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

struct Rain: Codable {
    
    private(set) var volume3Hours: Float // Rain volume for the last 3 hours
    
    private enum CodingKeys: String, CodingKey {
        case volume3Hours = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        volume3Hours = try container.decode(Float.self, forKey: .volume3Hours)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(volume3Hours, forKey: .volume3Hours)
    }
}

struct Snow: Codable {
    
    private(set) var volume3Hours: Float // Snow volume for the last 3 hours
    
    private enum CodingKeys: String, CodingKey {
        case volume3Hours = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        volume3Hours = try container.decode(Float.self, forKey: .volume3Hours)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(volume3Hours, forKey: .volume3Hours)
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
    
    private(set) var geoPoint: GeoPoint
    private(set) var weather: [Weather]
    private(set) var detailWeather: DetailWeather
    private(set) var wind: Wind?
    private(set) var clouds: Clouds?
    private(set) var rain: Rain?
    private(set) var snow: Snow?
    private(set) var cityName: String
    private(set) var cityIdentifier: Int?
    private var timeOfLastupdate: TimeInterval
    private(set) var system: System
   
    private var cod: Int
    
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
        case cod
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cod = try container.decode(Int.self, forKey: .cod)
        geoPoint = try container.decode(GeoPoint.self, forKey: .geoPoint)
        
        weather = try container.decode([Weather].self, forKey: .weather)
        detailWeather = try container.decode(DetailWeather.self, forKey: .detailWeather)
        wind = try? container.decode(Wind.self, forKey: .wind)
        clouds = try? container.decode(Clouds.self, forKey: .clouds)
        rain = try? container.decode(Rain.self, forKey: .rain)
        snow = try? container.decode(Snow.self, forKey: .snow)
        cityName = try container.decode(String.self, forKey: .cityName)
        cityIdentifier = try? container.decode(Int.self, forKey: .cityIdentifier)
        timeOfLastupdate = try container.decode(TimeInterval.self, forKey: .timeOfLastupdate)
        system = try container.decode(System.self, forKey: .system)
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
        try container.encode(cityName, forKey: .cityName)
        try? container.encode(cityIdentifier, forKey: .cityIdentifier)
        try container.encode(timeOfLastupdate, forKey: .timeOfLastupdate)
        try container.encode(system, forKey: .system)
        try container.encode(cod, forKey: .cod)
    }
    
    
    
}
