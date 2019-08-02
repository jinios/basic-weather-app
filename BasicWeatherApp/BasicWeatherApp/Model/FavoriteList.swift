//
//  FavoriteList.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 02/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation


class DataStorage<T: NSCoding> {
    
    class func load() -> T? {
        if UserDefaults.standard.object(forKey: String(describing: T.self)) != nil {
            guard let encodedData = UserDefaults.standard.data(forKey: String(describing: T.self)) else { return nil }
            guard let archivedMachine = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as? T else { return nil }
            return archivedMachine
        }
        return nil
    }
    
    class func save(data: T) {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: data), forKey: String(describing: T.self))
    }
}


class FavoriteList: NSObject, NSCoding {
    
    private static var sharedInstance = FavoriteList()
    
    private var cities: Set<Int> {
        didSet {
            DataStorage<FavoriteList>.save(data: self)
        }
    }
    
    static let shared: FavoriteList = {
        return sharedInstance
    }()
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cities, forKey: String(describing: FavoriteList.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        cities = aDecoder.decodeObject(forKey: String(describing: FavoriteList.self)) as! Set<Int>
    }
    
    private override init() {
        self.cities = Set<Int>()
    }
    
    private init(ids: [Int]) {
        self.cities = Set(ids)
    }
    
    static func sharedFromDataStorage(_ ids: [Int]) -> FavoriteList {
        sharedInstance = FavoriteList(ids: ids)
        return sharedInstance
    }
    
    static func loadSavedData(_ data: FavoriteList) {
        sharedInstance = data
    }
    
    static func isSameData(_ data: FavoriteList) -> Bool {
        return sharedInstance.cities == data.cities
    }
    
    func push(id: Int) -> Bool {
        let isPushed = self.cities.insert(id).inserted
        return isPushed
    }
    
    func pop(id: Int) -> Bool {
        var popResult: Bool
        let result = self.cities.remove(id)
        if result != nil {
            popResult = true
        } else {
            popResult = false
        }
        return popResult
    }
    
    func isFavorite(branchId: Int) -> Bool {
        guard cities.count > 0 else { return false }
        return cities.contains(branchId)
    }
    
    func ids() -> [Int] {
        return cities.sorted()
    }
    
    func isEmpty() -> Bool {
        return cities.isEmpty
    }
    
}
