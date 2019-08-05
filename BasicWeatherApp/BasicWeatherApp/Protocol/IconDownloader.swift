//
//  IconDownloader.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 05/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

protocol IconDownloader: class {
    func downloadIcon(of cell: IconPresentable, iconKey: String)
}

extension IconDownloader {
    func downloadIcon(of cell: IconPresentable, iconKey: String) {
        ImageSetter.fetch(iconKey: iconKey) { (imageData) in
            DispatchQueue.main.async {
                if let imageData = imageData {
                    cell.setWeatherIcon(image: UIImage(data: imageData))
                } else {
                    cell.setWeatherIcon(image: nil)
                }
            }
        }
    }
}

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


protocol MiscellaneousDetailWeather {
    var title: String { get }
    var value: String { get }
}


protocol FavoriteCityDelegate: class {
    func addCity(_ city: FavoriteCity)
}
