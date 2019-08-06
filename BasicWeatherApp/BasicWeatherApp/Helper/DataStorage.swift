//
//  DataStorage.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 02/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

final class DataStorage<T: Codable> {

    class func save(list: T) {
        guard let encoded = try? JSONEncoder().encode(list) else { return }
        UserDefaults.standard.set(encoded, forKey: String(describing: T.self))
    }

    class func load() -> T? {
        guard let savedData = UserDefaults.standard.object(forKey: String(describing: T.self)) as? Data else { return nil }
        guard let loadedData = try? JSONDecoder().decode(T.self, from: savedData) else { return nil }
        return loadedData
    }
}

