//
//  Clouds.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 05/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

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
