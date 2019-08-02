//
//  FavoriteCityTableViewCell.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class FavoriteCityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!

    var cityData: FavoriteCity? {
        didSet {
            guard let cityData = self.cityData else { return }
            self.cityName.text = cityData.location?.name
            let temperature = cityData.currentWeather?.detailWeather.temperature.rounded()
            self.currentTemperature.text = String(Int(temperature ?? 100))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
