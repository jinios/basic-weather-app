//
//  IconPresentable.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 07/08/2019.
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

