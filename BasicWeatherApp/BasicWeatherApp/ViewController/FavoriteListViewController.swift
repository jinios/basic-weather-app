//
//  FavoriteListViewController.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

class FavoriteCity {

    var location: LocationItem?
    var currentWeather: CurrentWeather?

    init(location: LocationItem, currentWeather: CurrentWeather?) {
        self.location = location
        self.currentWeather = currentWeather
    }
    
    static func == (lhs: FavoriteCity, rhs: FavoriteCity) -> Bool {
        return lhs.currentWeather?.cityID == rhs.currentWeather?.cityID
    }
    
}

protocol FavoriteCityDelegate: class {
    func addCity(locationitem: LocationItem, currentWeather: CurrentWeather)
}

class FavoriteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    var cities: [FavoriteCity]? {
        didSet {
            guard self.cities != nil else { return }
            self.tableView.reloadData()
        }
    }
    
    var cityIds: [Int] = [] {
        didSet {
            guard self.cityIds.count > 0 else { return }
            currentWeatherData()
        }
    }
    
    var weathers: [CurrentWeather] = [] {
        didSet {
            DispatchQueue.main.async {
                guard self.weathers.count > 0 else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
    }
    
    @IBAction func openSearchCity(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CitySearchViewController") as? CitySearchViewController else { return }
        nextVC.favoriteCityListManager = self
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func currentWeatherData() {
        let idstr = cityIds.map{String($0)}.joined(separator: ",")
        DataSetter.fetch(of: idstr, handler: reloadData(c:))
    }
    
    func reloadData(c: [CurrentWeather]) {
        guard self.cityIds.count == c.count else { return }
        self.weathers = c
    }

}

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCityTableViewCell", for: indexPath) as? FavoriteCityTableViewCell else { return UITableViewCell() }
        cell.weather = weathers[indexPath.row]
        
        return cell
    }
    
    
}

extension FavoriteListViewController: FavoriteCityDelegate {
    
    func addCity(locationitem locationItem: LocationItem, currentWeather: CurrentWeather) {
        if cities == nil {
            cities = [FavoriteCity]()
        }
        
        guard FavoriteList.shared.push(id: currentWeather.cityID ?? 0) else { return }
        self.cityIds = FavoriteList.shared.ids()
    }

}
