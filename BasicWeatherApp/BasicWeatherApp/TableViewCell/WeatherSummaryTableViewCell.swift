//
//  WeatherSummaryTableViewCell.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class WeatherSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    var summary: FavoriteCity? {
        didSet { self.set()}
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func set() {
        guard let summary = self.summary else { return }
        self.cityNameLabel.text = summary.location?.name
        self.descriptionLabel.text = summary.currentWeather?.weather[0].description
        self.temperatureLabel.text = String(summary.currentWeather?.detailWeather.temperature ?? 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
