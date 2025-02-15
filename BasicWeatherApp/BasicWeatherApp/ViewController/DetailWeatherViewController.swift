//
//  DetailWeatherViewController.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class DetailWeatherViewController: UIViewController, IconDownloader {

    @IBOutlet weak var tableView: UITableView!

    var detailWeatherInfo: DetailWeatherInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.detailWeatherInfo?.cityName
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.allowsSelection = false
    }
}


extension DetailWeatherViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherSummaryTableViewCell", for: indexPath) as! WeatherSummaryTableViewCell
            cell.summary = self.detailWeatherInfo?.city
            downloadIcon(of: cell, iconKey: cell.summary?.currentWeather?.weather.first?.icon ?? "")
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyWeatherTableViewCell", for: indexPath) as! HourlyWeatherTableViewCell
            cell.setDataSource(dataSource: self, at: indexPath.section)
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyWeatherTableViewCell", for: indexPath) as! WeeklyWeatherTableViewCell
            cell.setDataSource(dataSource: self, at: indexPath.section)
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentDetailTableViewCell", for: indexPath) as! CurrentDetailTableViewCell
            cell.setDataSource(dataSource: self, at: indexPath.section)
            return cell

        default:
            return UITableViewCell()
        }
    }

}


extension DetailWeatherViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 230
        case 1: return 130
        case 2:
            return CGFloat(50 * (self.detailWeatherInfo?.weeklyForecastCount ?? 0))
        case 3:
            let numberOfLine: CGFloat = CGFloat(self.detailWeatherInfo?.miscellaneousListCount ?? 0) / CGFloat(2)
            return CGFloat(60 * numberOfLine.rounded())
        default: return 400
        }
    }

}

extension DetailWeatherViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return self.detailWeatherInfo?.hourlyForecastCount ?? 0
        case 2:
            return self.detailWeatherInfo?.weeklyForecastCount ?? 0
        case 3:
            return self.detailWeatherInfo?.miscellaneousListCount ?? 0
        default: return 0
        }
    }

    // 1: Hourly, 2: Weekly, 3: CurrentDetail
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView.tag {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCollectionViewCell", for: indexPath) as! HourlyWeatherCollectionViewCell
            cell.forecast = detailWeatherInfo?.hourlyForecast(at: indexPath.row)
            downloadIcon(of: cell, iconKey: cell.forecast?.weather.first?.icon ?? "")
            return cell

        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyWeatherCollectionViewCell", for: indexPath) as! WeeklyWeatherCollectionViewCell
            cell.forecast = detailWeatherInfo?.weeklyForecast(at: indexPath.row)
            downloadIcon(of: cell, iconKey: cell.forecast?.iconName ?? "")
            return cell

        case 3: let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentDetailCollectionViewCell", for: indexPath) as! CurrentDetailCollectionViewCell
            cell.detailInfo = detailWeatherInfo?.miscellaneousDetail(at: indexPath.row)
            return cell
            
        default: return UICollectionViewCell()
        }
    }

}

extension DetailWeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView.tag == 3 {
            return CGSize(width: (view.bounds.width/2), height: 60.0)
        }
        return CGSize()
    }
}
