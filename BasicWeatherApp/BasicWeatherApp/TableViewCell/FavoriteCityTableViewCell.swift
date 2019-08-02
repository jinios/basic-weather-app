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
    
    var location: LocationItem? {
        didSet {
            guard let location = self.location else { return }
            self.cityName.text = location.name
        }
    }
    
    var cityData: FavoriteCity? {
        didSet {
            guard let cityData = self.cityData else { return }
            self.cityName.text = cityData.location?.name
            self.currentTemperature.text = String(cityData.currentWeather?.detailWeather.temperature ?? 100)
        }
    }
    
    var weather: CurrentWeather? {
        didSet {
            guard let weather = self.weather else { return }
            self.cityName.text = weather.cityName
            self.currentTemperature.text = String(Int(weather.detailWeather.temperature.rounded()) ?? 100)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
