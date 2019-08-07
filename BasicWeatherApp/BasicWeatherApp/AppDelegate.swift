//
//  AppDelegate.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let loaded = DataStorage<FavoriteList>.load() {
            FavoriteList.load(data: loaded)
        }
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        if let loaded = DataStorage<FavoriteList>.load() {
            FavoriteList.load(data: loaded)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        DataStorage<FavoriteList>.save(list: FavoriteList.shared)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataStorage<FavoriteList>.save(list: FavoriteList.shared)
    }


}

