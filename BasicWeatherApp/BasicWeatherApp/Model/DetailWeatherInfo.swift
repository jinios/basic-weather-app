//
//  DetailWeatherInfo.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 06/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

struct DetailWeatherInfo {
    private(set) var city: FavoriteCity
    private(set) var forecast: Forecast
    private(set) var miscellaneousWeatherList: [MiscellaneousDetailWeather] = []

    init(city: FavoriteCity, forecast: Forecast) {
        self.city = city
        self.forecast = forecast
        makeMiscellaneousWeatherList()
    }

    var cityName: String? {
        return self.city.location?.name
    }

    var miscellaneousListCount: Int {
        return miscellaneousWeatherList.count
    }

    var weeklyForecastCount: Int {
        return forecast.weeklyForecast().count
    }

    var hourlyForecastCount: Int {
        return forecast.hourlyForecast().count
    }

    private mutating func makeMiscellaneousWeatherList() {
        let details: [MiscellaneousDetailWeather?] =
            [city.currentWeather?.clouds,
             city.currentWeather?.detailWeather.humidity,
             forecast.list[0].rain,
             forecast.list[0].snow,
             city.currentWeather?.wind,
             city.currentWeather?.detailWeather.pressure]

        self.miscellaneousWeatherList = details.compactMap { $0 }
    }

    func miscellaneousDetail(at index: Int) -> MiscellaneousDetailWeather {
        return miscellaneousWeatherList[index]
    }

    func hourlyForecast(at index: Int) -> ForecastWeather? {
        return forecast.hourlyForecast()[index]
    }

    func weeklyForecast(at index: Int) -> ForecastWeather? {
        return forecast.weeklyForecast()[index]
    }
}

