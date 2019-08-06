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

    private var cities: [FavoriteCity]

    static let shared: FavoriteList = {
        return sharedInstance
    }()

    private init(cities: [FavoriteCity]) {
        self.cities = cities
    }
    
    private init() {
        self.cities = [FavoriteCity]()
    }

    static func load(data: FavoriteList) {
        sharedInstance = data
    }

    static func isSameData(_ data: FavoriteList) -> Bool {
        return sharedInstance.cities == data.cities
    }
    
    fileprivate func add(_ city: FavoriteCity) -> Bool {
        guard !cities.contains(city) else { return false }
        self.cities.append(city)
        return true
    }

    fileprivate func remove(at index: Int) {
        cities.remove(at: index)
    }

    fileprivate func cityList() -> [FavoriteCity] {
        return Array(self.cities)
    }

    fileprivate func isEmpty() -> Bool {
        return cities.isEmpty
    }

    fileprivate func city(at index: Int) -> FavoriteCity {
        return self.cities[index]
    }

    fileprivate func count() -> Int {
        return self.cities.count
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
        cities = try container.decode([FavoriteCity].self, forKey: .cities)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cities, forKey: .cities)
    }

}

class FavoriteCityManager {

    var userLocationCity: FavoriteCity?
    var presentableDelegate: FavoriteListPresentable?

    var hasUserLocationCity: Bool {
        guard let userLocationCity = self.userLocationCity else { return false }
        return userLocationCity.location?.isUserLocation ?? false
    }

    var count: Int {
        let totalCount = FavoriteList.shared.count()

        if self.userLocationCity != nil {
            return totalCount + 1
        } else {
            return totalCount
        }
    }

    func update(userLocationCity: FavoriteCity) -> Bool {
        if let previousCity = self.userLocationCity, previousCity == userLocationCity {
            presentableDelegate?.updateList()
            return false
        } else {
            self.userLocationCity = userLocationCity // 이전 위치와 다르면 새로운 위치 넣어줌
            presentableDelegate?.updateList()
            return true
        }

    }

    func city(at index: Int) -> FavoriteCity? {
        if let userLocationCity = self.userLocationCity {
            if index == 0 {
                return userLocationCity
            } else {
                return FavoriteList.shared.city(at: index - 1)
            }
        } else {
            return FavoriteList.shared.city(at: index)
        }
    }

    func remove(at index: Int) {
        let removeIndex = userLocationCity != nil ? index - 1 : index
        FavoriteList.shared.remove(at: removeIndex)
        presentableDelegate?.updateList()
    }

    func add(_ city: FavoriteCity) {
        guard FavoriteList.shared.add(city) else { return }
        presentableDelegate?.updateList()
    }

}

protocol FavoriteListPresentable: class {
    func updateList()
}
