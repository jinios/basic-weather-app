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

    func hourlyForecast() -> [ForecastWeather] {
        let filteredList = self.list.filter {
            $0.dateText?.convertDate?.isFuture(from: Date().convertKST()) ?? false
        }
        return filteredList
    }

    func weeklyForecast() -> [WeekdayForecast] {
        let weekdayList = list.map { forecast in
            return WeekdayForecast(dateOfWeek: (forecast.dateText?.convertDate?.toString(formatter: "yyyy-MM-dd")) ?? "",
                                   maxTemperature: forecast.detailWeather.maxTemperature,
                                   minTemperature: forecast.detailWeather.minTemperature,
                                   iconName: forecast.weather[0].icon)


        }

        let groupedList = Dictionary(grouping: weekdayList, by: { $0.dateOfWeek })

        var maxTemperatureList = [String: Float]()
        var minTemperatureList = [String: Float]()
        var iconList = [String: String]()

        for (key,value) in groupedList {
            let max = value.sorted(by: { $0.maxTemperature > $1.maxTemperature })[0].maxTemperature
            maxTemperatureList[key] = max

            let min = value.sorted(by: { $0.minTemperature < $1.minTemperature })[0].minTemperature
            minTemperatureList[key] = min

            let icon = value[0].iconName
            iconList[key] = icon
        }

        var result = [WeekdayForecast]()

        for (key,value) in maxTemperatureList {
            let weekDayForecast = WeekdayForecast(dateOfWeek: key, maxTemperature: value, minTemperature: minTemperatureList[key] ?? 0, iconName: iconList[key] ?? "")
            result.append(weekDayForecast)
        }

        return result
    }
}

struct WeekdayForecast {
    var dateOfWeek: String
    var maxTemperature: Float
    var minTemperature: Float
    var iconName: String
}
