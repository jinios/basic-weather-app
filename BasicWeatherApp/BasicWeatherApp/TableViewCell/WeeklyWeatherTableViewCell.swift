//
//  WeeklyWeatherTableViewCell.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class WeeklyWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weeklyWeatherCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDataSource(dataSource: UICollectionViewDataSource, at row: Int) {
        weeklyWeatherCollectionView.dataSource = dataSource
        weeklyWeatherCollectionView.tag = row
        weeklyWeatherCollectionView.reloadData()
    }


}
