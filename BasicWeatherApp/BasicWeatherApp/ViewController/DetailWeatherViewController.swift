//
//  DetailWeatherViewController.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 03/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class DetailWeatherViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var weatherInfo: FavoriteCity?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(weatherInfo)

    }

}


extension DetailWeatherViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyWeatherTableViewCell", for: indexPath) as? HourlyWeatherTableViewCell
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyWeatherTableViewCell", for: indexPath) as? WeeklyWeatherTableViewCell
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentDetailTableViewCell", for: indexPath) as? CurrentDetailTableViewCell
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}


extension DetailWeatherViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 200
        case 1: return 250
        case 2: return 300
        default: return 250
        }
    }

}
