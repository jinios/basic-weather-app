//
//  WeeklyWeatherCollectionViewCell.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class WeeklyWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!

    var forecast: ForecastWeather? {
        didSet {
            self.set()
        }
    }

    func set() {
        guard let forecast = self.forecast else { return }
        weekdayLabel.text = forecast.dateText?.convertDate?.dayOfWeek()
        maxTemperatureLabel.text = forecast.detailWeather.maxTemperature.text
        minTemperatureLabel.text = forecast.detailWeather.minTemperature.text
    }

}
