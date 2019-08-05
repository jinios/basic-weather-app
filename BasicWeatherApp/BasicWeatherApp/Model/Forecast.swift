//
//  Forecast.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 05/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

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
