//
//  KeyInfoLoader.swift
//  WeatherApp
//
//  Created by YOUTH2 on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

class KeyInfoLoader {

    static let path = Bundle.main.path(forResource: "KeyInfo", ofType: "plist")

    class func loadValue(of key: KeyInfo) -> String? {
        guard let path = path else { return nil }
        guard let myDict = NSDictionary(contentsOfFile: path) else { return nil }
        guard let value = myDict[key.rawValue] as? String else { return nil }
        return value
    }

}

enum KeyInfo: String {
    case WeatherBaseURL
    case APIKey
    case IconBaseURL
}


