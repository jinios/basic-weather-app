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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
    }
    
    @IBAction func openSearchCity(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CitySearchViewController") as? CitySearchViewController else { return }
        nextVC.favoriteCityListManager = self
        self.present(nextVC, animated: true, completion: nil)
    }

}

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCityTableViewCell", for: indexPath) as? FavoriteCityTableViewCell else { return UITableViewCell() }
        guard let cities = self.cities else { return UITableViewCell() }
        cell.cityData = cities[indexPath.row]
        
        return cell
    }
    
    
}

extension FavoriteListViewController: FavoriteCityDelegate {
    
    func addCity(locationitem locationItem: LocationItem, currentWeather: CurrentWeather) {
        if cities == nil {
            cities = [FavoriteCity]()
        }
        cities?.append(FavoriteCity(location: locationItem, currentWeather: currentWeather))
    }

}
