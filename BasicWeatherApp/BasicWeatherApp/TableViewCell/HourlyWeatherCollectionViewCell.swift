//
//  HourlyWeatherCollectionViewCell.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell, IconPresentable {

    var forecast: ForecastWeather? {
        didSet {
            self.set()
        }
    }

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    func set() {
        guard let forecast = self.forecast else { return }
        self.timeLabel.text = forecast.dateText?.convertDate?.convertAMPMHHMM()
        self.temperatureLabel.text = forecast.detailWeather.temperature.text
    }

}
