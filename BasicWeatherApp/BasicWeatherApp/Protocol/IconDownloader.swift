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

