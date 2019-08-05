//
//  FavoriteListViewController.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController, IconDownloader {

    @IBOutlet weak var tableView: UITableView!
   
    var cities: [FavoriteCity] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        self.navigationItem.title = "즐겨찾는 도시"
    }
    
    @IBAction func openSearchCity(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CitySearchViewController") as? CitySearchViewController else { return }
        nextVC.favoriteCityDelegate = self

        self.present(nextVC, animated: true, completion: nil)
    }

    func fetchForecast(at index: Int) {
        DataSetter.fetch(of: self.cities[index]) { forecast, city in
            self.pushToDetailWeather(forecast: forecast, city: city)
        }
    }

    func pushToDetailWeather(forecast: Forecast, city: FavoriteCity) {
        guard let detailWeatherVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailWeatherViewController") as? DetailWeatherViewController else { return }
        detailWeatherVC.city = city
        detailWeatherVC.weatherInfo = forecast

        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailWeatherVC, animated: true)
        }
    }

}

extension FavoriteListViewController: LocationTrackingDelegate {

    func currentLocation(_ location: LocationItem?) {
        guard let locationItem = location else { return }
        DataSetter.fetch(of: locationItem) { (favoriteCity) in
            self.cities.insert(favoriteCity, at: 0) // add weather of current user location at firstIndex
        }
    }
}


extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCityTableViewCell", for: indexPath) as? FavoriteCityTableViewCell else { return UITableViewCell() }
        cell.cityData = self.cities[indexPath.row]
        downloadIcon(of: cell, iconKey: cell.cityData?.currentWeather?.weather.first?.icon ?? "")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.fetchForecast(at: indexPath.row)
    }
    
}

extension FavoriteListViewController: FavoriteCityDelegate {
    
    func addCity(_ city: FavoriteCity) {
        self.cities.append(city)
    }

}


struct FavoriteCity: Hashable {

    var location: LocationItem?
    var currentWeather: CurrentWeather?

    func hash(into hasher: inout Hasher) {
        return hasher.combine(currentWeather?.cityID ?? 0)
    }

    init(location: LocationItem, currentWeather: CurrentWeather?) {
        self.location = location
        self.currentWeather = currentWeather
    }

    static func == (lhs: FavoriteCity, rhs: FavoriteCity) -> Bool {
        return lhs.currentWeather?.cityID == rhs.currentWeather?.cityID
    }
}

