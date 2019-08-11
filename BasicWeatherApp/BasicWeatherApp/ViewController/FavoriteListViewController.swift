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

    private var locationTracker: LocationTracker?
    private var favoriteCityManager: FavoriteCityManager?

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAllList), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.blue

        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        self.navigationItem.title = "즐겨찾는 도시"
        tableView.addSubview(self.refreshControl)

        favoriteCityManager = FavoriteCityManager()
        favoriteCityManager?.presentableDelegate = self

        locationTracker = LocationTracker()
        locationTracker?.locationTrackingdelegate = self
        locationTracker?.getLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @IBAction func openSearchCity(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CitySearchViewController") as? CitySearchViewController else { return }
        nextVC.favoriteCityDelegate = self

        self.present(nextVC, animated: true, completion: nil)
    }

    func fetchForecast(at index: Int) {
        guard let selectedCity = favoriteCityManager?.city(at: index) else { return }

        let url = API.url(baseURL: KeyInfoLoader.loadValue(of: .WeatherBaseURL),
                          parameters: QueryItemMaker.weatherAPIquery(city: selectedCity.location),
                          pathComponent: RequestType.forecastWeather)

        DataSetter.fetch(of: selectedCity, url: url) { [weak self] (forecast, city, error) in
            if let error = error {
                SlackWebhook.fire(message: error.body())
                self?.sendErrorAlert()
            }

            guard let forecast = forecast else { return }
            guard let city = city else { return }
            self?.pushToDetailWeather(forecast: forecast, city: city)
        }
    }

    func pushToDetailWeather(forecast: Forecast, city: FavoriteCity) {
        guard let detailWeatherVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailWeatherViewController") as? DetailWeatherViewController else { return }
        let detailWeather = DetailWeatherInfo(city: city, forecast: forecast)
        detailWeatherVC.detailWeatherInfo = detailWeather

        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailWeatherVC, animated: true)
        }
    }

    @objc func refreshAllList() {
        self.updateAllCityWeather()
        refreshControl.endRefreshing()
    }

    func updateAllCityWeather() {
        guard let favoriteCityManager = self.favoriteCityManager else { return }

        for index in 0..<favoriteCityManager.count {
            guard let selectedCity = favoriteCityManager.city(at: index) else { return }

            if favoriteCityManager.isNeedToUpdate(at: index) {

                let url = API.url(baseURL: KeyInfoLoader.loadValue(of: .WeatherBaseURL),
                                  parameters: QueryItemMaker.weatherAPIquery(city: selectedCity.location),
                                  pathComponent: RequestType.currentWeather)

                DataSetter.fetch(url: url!, index: index, type: CurrentWeather.self) { [weak self] result in

                    switch result {
                    case let .success(currentWeather):
                        let favoriteCity = FavoriteCity(location: selectedCity.location!, currentWeather: currentWeather)
                        self?.favoriteCityManager?.replace(city: favoriteCity, at: index)
                    case let .failure(_, apiErrorMessage):
                        guard let apiErrorMessage = apiErrorMessage else { break }
                        self?.sendErrorAlert(error: apiErrorMessage)
                    }
                }
            } else {
                continue
            }
        }
    }

}

extension FavoriteListViewController: LocationTrackingDelegate {

    func currentLocation(_ location: LocationItem?) {
        guard let locationItem = location else { return }

        let url = API.url(baseURL: KeyInfoLoader.loadValue(of: .WeatherBaseURL),
                          parameters: QueryItemMaker.weatherAPIquery(city: locationItem),
                          pathComponent: RequestType.currentWeather)

        DataSetter.fetch(of: locationItem, url: url) { [weak self] (favoriteCity, error) in

            if let error = error {
                SlackWebhook.fire(message: error.body())
                self?.sendErrorAlert()
            }

            guard let favoriteCity = favoriteCity else { return }
            self?.favoriteCityManager?.update(userLocationCity: favoriteCity)
        }

    }
}

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteCityManager?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCityTableViewCell", for: indexPath) as? FavoriteCityTableViewCell else { return UITableViewCell() }
        cell.cityData = favoriteCityManager?.city(at: indexPath.row)
        downloadIcon(of: cell, iconKey: cell.cityData?.currentWeather?.weather.first?.icon ?? "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.fetchForecast(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard let hasUserLocationCity = favoriteCityManager?.hasUserLocationCity else { return .delete }
        guard hasUserLocationCity else { return .delete }

        return indexPath.row == 0 ? .none: .delete
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard indexPath.row != 0 else { return nil }

        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { [weak self] (action, indexPath) in
            self?.favoriteCityManager?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        return [delete]
    }
}

extension FavoriteListViewController: FavoriteCityDelegate {
    
    func addCity(_ city: FavoriteCity) {
        favoriteCityManager?.add(city)
    }

}

extension FavoriteListViewController: FavoriteListPresentable {

    func updateList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


    func updateRow(index: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .right)
        }
    }


}

extension FavoriteListViewController: ErrorAlertPresentable {

    func sendErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController.make()
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
