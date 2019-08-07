//
//  HourlyWeatherTableViewCell.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class HourlyWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setDataSource(dataSource: UICollectionViewDataSource, at index: Int) {
        hourlyWeatherCollectionView.dataSource = dataSource
        hourlyWeatherCollectionView.tag = index
        hourlyWeatherCollectionView.reloadData()
    }

}

