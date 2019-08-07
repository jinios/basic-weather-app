//
//  API.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 07/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

struct API {

    static func url(baseURL: String?, parameters: [String:String], pathComponent: RequestType?) -> URL? {
        guard let baseURL = baseURL else { return nil }
        guard var base = URL(string: baseURL) else { return nil }

        if let path = pathComponent?.rawValue {
            base.appendPathComponent(path)
        }

        var urlComponents = URLComponents(url: base, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = parameters.map { return URLQueryItem(name: $0.key, value: $0.value) }

        return urlComponents?.url
    }

}

enum RequestType: String {
    case currentWeather = "weather"
    case forecastWeather = "forecast"
}

