//
//  DataSetter.swift
//  WeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

// class DataSetter<T: LocationItemProtocol, U: RequestForecastType,
class DataSetter<T: LocationItem> {
    
    class func fetch(of city: T, handler: @escaping((LocationItem, CurrentWeather) -> Void)) {
        guard let lat = city.latitude else { return }
        guard let lng = city.longitude else { return }
        guard let baseUrl = KeyInfoLoader.loadValue(of: .WeatherBaseURL) else { return }
        guard let appId = KeyInfoLoader.loadValue(of: .APIKey) else { return }
        
        var base = URL(string: baseUrl)
        base?.appendPathComponent("weather")
        
        var urlComponents = URLComponents(url: base!, resolvingAgainstBaseURL: true)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: QueryItemKey.latitude.rawValue, value: String(lat)),
            URLQueryItem(name: QueryItemKey.longitude.rawValue, value: String(lng)),
            URLQueryItem(name: QueryItemKey.units.rawValue, value: "metric"),
            URLQueryItem(name: QueryItemKey.appid.rawValue, value: appId)
        ]
        
        guard let sessionUrl = urlComponents?.url else { return }
        let configure = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = 15
        let urlSession = URLSession(configuration: configure)
        
        urlSession.dataTask(with: sessionUrl) {(data, response, err) in
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                do {
                    print(data.prettyPrintedJSONString!)
                    let currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                    handler(city, currentWeather)
                } catch {
                    print("FAIL TO DECODE")
                }
            }
            }.resume()
    }
}
