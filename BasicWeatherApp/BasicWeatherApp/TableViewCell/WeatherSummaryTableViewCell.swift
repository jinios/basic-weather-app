//
//  WeatherSummaryTableViewCell.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class WeatherSummaryTableViewCell: UITableViewCell, IconPresentable {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!

    var summary: FavoriteCity? {
        didSet { self.set()}
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func set() {
        guard let summary = self.summary else { return }
        self.cityNameLabel.text = summary.location?.name
        self.descriptionLabel.text = summary.currentWeather?.weather[0].description
        self.temperatureLabel.text = summary.currentWeather?.detailWeather.temperature.text

        let sunriseDate = Date(timeIntervalSince1970: summary.currentWeather?.system?.sunrise ?? 0)
        let sunsetDate = Date(timeIntervalSince1970: summary.currentWeather?.system?.sunset ?? 0)
        self.sunriseTimeLabel.text = "↑ \(sunriseDate.convertAMPMHHMM())"
        self.sunsetTimeLabel.text = "↓ \(sunsetDate.convertAMPMHHMM())"
    }


}
