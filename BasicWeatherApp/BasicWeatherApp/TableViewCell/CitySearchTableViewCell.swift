//
//  CitySearchTableViewCell.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class CitySearchTableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    
    var city: String? {
        didSet {
            guard let city = self.city else { return }
            self.cityName.text = city
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
