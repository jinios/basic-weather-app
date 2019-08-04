//
//  CurrentDetailTableViewCell.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class CurrentDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var currentDetailCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    func setDataSource(dataSource: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout, at row: Int) {
        currentDetailCollectionView.dataSource = dataSource
        currentDetailCollectionView.delegate = dataSource
        currentDetailCollectionView.tag = row
        currentDetailCollectionView.reloadData()
    }

}
