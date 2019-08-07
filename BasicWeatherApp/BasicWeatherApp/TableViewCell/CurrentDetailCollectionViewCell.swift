//
//  CurrentDetailCollectionViewCell.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class CurrentDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    var detailInfo: MiscellaneousDetailWeather? {
        didSet {
            self.set()
        }
    }

    func set() {
        guard let detailInfo = self.detailInfo else { return }
        self.titleLabel.text = detailInfo.title
        self.infoLabel.text = detailInfo.value
    }

}
