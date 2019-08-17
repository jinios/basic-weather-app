//
//  ViewController.swift
//  BasicWeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit
import MapKit

class CitySearchViewController: UIViewController, ErrorAlertPresentable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locationSearchCompleter: MKLocalSearchCompleter?
    weak var favoriteCityDelegate: FavoriteCityDelegate?
    
    var resultCities: [MKLocalSearchCompletion]? {
        didSet {
            guard self.resultCities != nil else { return }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSearchCompleter = MKLocalSearchCompleter()
        locationSearchCompleter?.delegate = self
        locationSearchCompleter?.filterType = .locationsOnly
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    private func dismiss() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeCitySearch(_ sender: Any) {
        dismiss()
    }

    
}

// MARK: - UISearchBarDelegate

extension CitySearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchBarIsEmpty() else {
            resultCities?.removeAll()
            return
        }
        locationSearchCompleter?.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension CitySearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard !searchBarIsEmpty() else {
            resultCities?.removeAll()
            return
        }
        resultCities = completer.results.filter { $0.subtitle.isEmpty }
    }
}

// MARK: - UITableViewDataSource

extension CitySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultCities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CitySearchTableViewCell", for: indexPath) as? CitySearchTableViewCell else { return UITableViewCell() }
        guard let city = resultCities?[indexPath.row] else { return UITableViewCell() }
        
        cell.city = city.title
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CitySearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let completer = resultCities?[indexPath.row] else { return }

        let selectedCityName = completer.title
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = selectedCityName
        
        MKLocalSearch(request: request).start { (response, error) in
            if let error = error as? MKError {
                print(error)
                return
            }
            guard let mapItem = response?.mapItems.first,
                let name = mapItem.name else {
                    return
            }
            
            let lat = mapItem.placemark.coordinate.latitude
            let lng = mapItem.placemark.coordinate.longitude
            
            let locationItem = LocationItem(latitude: lat, longitude: lng, name: name)

            let url = API.url(baseURL: KeyInfoLoader.loadValue(of: .WeatherBaseURL),
                              parameters: QueryItemMaker.weatherAPIquery(city: locationItem),
                              pathComponent: RequestType.currentWeather)

            DataSetter.fetch(url: url!, index: nil, type: CurrentWeather.self) { [weak self] result in

                switch result {
                case let .success(currentWeather):
                    let favoriteCity = FavoriteCity(location: locationItem, currentWeather: currentWeather)
                    self?.addFavoriteCity(favoriteCity)
                    
                case let .failure(_, apiErrorMessage):
                    DispatchQueue.main.async {
                        guard let apiErrorMessage = apiErrorMessage else { return }
                        self?.sendErrorAlert(error: apiErrorMessage)
                    }
                }
            }

        }
    }
    
    func addFavoriteCity(_ city: FavoriteCity) {
        DispatchQueue.main.async {
            self.favoriteCityDelegate?.addCity(city)
            self.dismiss()
        }
    }

}

extension CitySearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

