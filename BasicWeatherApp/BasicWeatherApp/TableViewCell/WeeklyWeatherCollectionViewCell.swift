//
//  WeeklyWeatherCollectionViewCell.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class WeeklyWeatherCollectionViewCell: UICollectionViewCell, IconPresentable{

    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!

    var forecast: WeekdayForecast? {
        didSet {
            self.set()
        }
    }

    func set() {
        guard let forecast = self.forecast else { return }
        weekdayLabel.text = forecast.dateOfWeek.toDate()?.dayOfWeek() ?? ""
        maxTemperatureLabel.text = forecast.maxTemperature.text
        minTemperatureLabel.text = forecast.minTemperature.text
    }

}
