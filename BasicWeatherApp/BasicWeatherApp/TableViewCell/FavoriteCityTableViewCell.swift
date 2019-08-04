//
//  FavoriteCityTableViewCell.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

protocol IconPresentable: class {
    var weatherIconImageView: UIImageView! { get }
    func setWeatherIcon(image: UIImage?)
}

extension IconPresentable {
    func setWeatherIcon(image: UIImage?) {
        guard let image = image else { return }
        weatherIconImageView.image = image
    }
}

class FavoriteCityTableViewCell: UITableViewCell, IconPresentable {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!

    var cityData: FavoriteCity? {
        didSet {
            guard let cityData = self.cityData else { return }
            self.cityName.text = cityData.location?.name
            self.currentTemperature.text = cityData.currentWeather?.detailWeather.temperature.text
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
