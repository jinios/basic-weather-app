//
//  CurrentDetailCollectionViewCell.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class CurrentDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    var detailInfo: MiscellaneousDetailWeather? {
        didSet {
            self.set()
        }
    }

    func set() {
        guard let detailInfo = self.detailInfo else { return }
        self.titleLabel.text = detailInfo.title
        self.infoLabel.text = detailInfo.value
    }

}

protocol MiscellaneousDetailWeather {
    var title: String { get }
    var value: String { get }
}

struct CurrentDetailList {

    private let currentWeather: CurrentWeather
    private var miscellaneousWeatherList: [MiscellaneousDetailWeather] = []

    var count: Int {
        return miscellaneousWeatherList.count
    }

    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
        makeMiscellaneousWeatherList()
    }

    private mutating func makeMiscellaneousWeatherList() {
        let details: [MiscellaneousDetailWeather?] =
            [currentWeather.clouds,
             currentWeather.detailWeather.humidity,
             currentWeather.rain,
             currentWeather.snow,
             currentWeather.wind,
             currentWeather.detailWeather.pressure]

        miscellaneousWeatherList = details.compactMap { $0 }
    }

    func miscellaneousDetail(at index: Int) -> MiscellaneousDetailWeather {
        return miscellaneousWeatherList[index]
    }

}
