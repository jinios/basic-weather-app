//
//  FavoriteList.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 02/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

final class FavoriteList {
    
    private static var sharedInstance = FavoriteList()
    
    private var cities: Set<FavoriteCity>
    
    static let shared: FavoriteList = {
        return sharedInstance
    }()

    private init(citySet: Set<FavoriteCity>) {
        self.cities = citySet
    }
    
    private init() {
        self.cities = Set<FavoriteCity>()
    }
    
    private init(ids: [FavoriteCity]) {
        self.cities = Set(ids)
    }

    static func load(data: FavoriteList) {
        sharedInstance = data
    }

    static func isSameData(_ data: FavoriteList) -> Bool {
        return sharedInstance.cities == data.cities
    }
    
    func push(_ city: FavoriteCity) -> Bool {
        let isPushed = self.cities.insert(city).inserted
        return isPushed
    }
    
    func pop(_ city: FavoriteCity) -> Bool {
        var popResult: Bool
        let result = self.cities.remove(city)
        // TODO: 삼항연산자 사용
        if result != nil {
            popResult = true
        } else {
            popResult = false
        }
        return popResult
    }

    func cityList() -> Set<FavoriteCity> {
        return self.cities
    }

    func isEmpty() -> Bool {
        return cities.isEmpty
    }
    
}

// MARK: Codable

extension FavoriteList: Codable {

    private enum CodingKeys: String, CodingKey {
        case cities
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cities = try container.decode(Set<FavoriteCity>.self, forKey: .cities)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cities, forKey: .cities)
    }

}
