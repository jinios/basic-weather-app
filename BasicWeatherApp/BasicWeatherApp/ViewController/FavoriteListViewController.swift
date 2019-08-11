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

        DataSetter.fetch(url: url!, index: nil, type: Forecast.self) { [weak self] result in

            switch result {
            case let .success(forecast):
                let detailWeatherInfo = DetailWeatherInfo(city: selectedCity, forecast: forecast)
                self?.pushToDetailWeather(info: detailWeatherInfo)
            case let .failure(_, apiErrorMessage):
                guard let apiErrorMessage = apiErrorMessage else { break }
                self?.sendErrorAlert(error: apiErrorMessage)
            }
        }

    }


    func pushToDetailWeather(info detailWeather: DetailWeatherInfo) {
        guard let detailWeatherVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailWeatherViewController") as? DetailWeatherViewController else { return }
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

            guard favoriteCityManager.isNeedToUpdate(at: index) else { continue }
            
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
        }
    }

}

extension FavoriteListViewController: LocationTrackingDelegate {

    func currentLocation(_ location: LocationItem?) {
        guard let locationItem = location else { return }

        let url = API.url(baseURL: KeyInfoLoader.loadValue(of: .WeatherBaseURL),
                          parameters: QueryItemMaker.weatherAPIquery(city: locationItem),
                          pathComponent: RequestType.currentWeather)

        DataSetter.fetch(url: url!, index: nil, type: CurrentWeather.self) { [weak self] result in

            switch result {
            case let .success(currentWeather):
                let favoriteCity = FavoriteCity(location: locationItem, currentWeather: currentWeather)
                self?.favoriteCityManager?.update(userLocationCity: favoriteCity)
            case let .failure(_, apiErrorMessage):
                guard let apiErrorMessage = apiErrorMessage else { break }
                self?.sendErrorAlert(error: apiErrorMessage)
            }
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
            self.tableView.reloadRows(at: [indexPath], with: .top)
        }
    }
}

extension FavoriteListViewController: ErrorAlertPresentable {

    func sendErrorAlert(error: APIErrorMessage) {
        DispatchQueue.main.async {
            let action = UIAlertAction(title: "Done", style: .default) { _ in
                SlackWebhook.fire(message: error.body())
            }
            let alert = UIAlertController.make(action: action)
            self.present(alert, animated: true, completion: nil)
        }
    }

}

