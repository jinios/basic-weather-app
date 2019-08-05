//
//  Wind.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 05/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

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
