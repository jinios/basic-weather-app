//
//  Snow.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 05/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

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
