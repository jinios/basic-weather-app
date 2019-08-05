//
//  FavoriteCityTableViewCell.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class FavoriteCityTableViewCell: UITableViewCell, IconPresentable {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var currentUserLocationFlagLabel: UILabel!

    var cityData: FavoriteCity? {
        didSet {
            guard let cityData = self.cityData else { return }
            self.cityName.text = cityData.location?.name
            self.currentTemperature.text = cityData.currentWeather?.detailWeather.temperature.text
            self.currentUserLocationFlagLabel.isHidden = !(self.cityData?.location?.isTrackedLocation ?? false)
            self.currentUserLocationFlagLabel.transform = CGAffineTransform(rotationAngle: -45.0)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
