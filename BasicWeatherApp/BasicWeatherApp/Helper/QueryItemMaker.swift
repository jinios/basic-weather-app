//
//  QueryItemMaker.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 07/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

struct QueryItemMaker {

    static func weatherAPIquery(city: WeatherLocationInformative?) -> [String:String] {
        guard let lat = city?.latitude else { return [:] }
        guard let lng = city?.longitude else { return [:] }
        guard let appId = KeyInfoLoader.loadValue(of: .APIKey) else { return [:] }

        return [
            QueryItemKey.latitude.rawValue: String(lat),
            QueryItemKey.longitude.rawValue: String(lng),
            QueryItemKey.units.rawValue: "metric",
            QueryItemKey.language.rawValue: "kr",
            QueryItemKey.appid.rawValue: appId
        ]
    }

}

enum QueryItemKey: String {
    case latitude = "lat"
    case longitude = "lon"
    case cityId = "id"
    case appid
    case units
    case language = "lang"
}

