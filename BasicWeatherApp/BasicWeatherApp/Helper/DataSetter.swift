//
//  DataSetter.swift
//  WeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

enum Result<T: Decodable> {
    case success(T)
    case failure(Error?, APIErrorMessage?)
}


final class DataSetter {

    class func fetch<T: Decodable>(url: URL, index: Int, type: T.Type, handler: @escaping ((Result<T>) -> Void)) {

        let configure = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = 15

        let urlSession = URLSession(configuration: configure)
        urlSession.dataTask(with: url) {(data, response, err) in

            if let error = err {
                let errorMessage = APIErrorMessage(brokenUrl: url,
                                                   data: data,
                                                   type: .Network,
                                                   error: error)
                handler(.failure(error, errorMessage))
            }

            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {

                do {
                    let currentWeather = try JSONDecoder().decode(T.self, from: data)
                    handler(.success(currentWeather))
                } catch {
                    let errorMessage = APIErrorMessage(brokenUrl: url,
                                                       data: data,
                                                       type: .Parsing,
                                                       error: nil)
                    handler(.failure(error, errorMessage))
                }
            }
        }.resume()
    }




    class func fetch(of city: LocationItem, url: URL?, timeout: TimeInterval = 15, handler: @escaping((FavoriteCity?, APIErrorMessage?) -> Void)) {

        let configure = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = timeout

        let urlSession = URLSession(configuration: configure)


        urlSession.dataTask(with: url!) {(data, response, err) in

            if let error = err {
                let errorMessage = APIErrorMessage(brokenUrl: url,
                                                   data: data,
                                                   type: .Network,
                                                   error: error)
                handler(nil, errorMessage)
            }

            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {

                do {
                    let currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                    let city = FavoriteCity(location: city, currentWeather: currentWeather)

                    handler(city, nil)
                } catch {
                    let errorMessage = APIErrorMessage(brokenUrl: url,
                                                       data: data,
                                                       type: .Parsing,
                                                       error: nil)
                    handler(nil, errorMessage)
                }
            } else {
                let errorMessage = APIErrorMessage(brokenUrl: url,
                                                   data: data,
                                                   type: .Parsing,
                                                   error: nil)
                handler(nil, errorMessage)
            }
            }.resume()
    }


    class func fetch(of city: FavoriteCity, url: URL?, timeout: TimeInterval = 15, handler: @escaping((Forecast?, FavoriteCity?, APIErrorMessage?) -> Void)) {

        let configure = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = timeout
        let urlSession = URLSession(configuration: configure)

        urlSession.dataTask(with: url!) {(data, response, err) in

            if let error = err {
                let errorMessage = APIErrorMessage(brokenUrl: url,
                                                   data: data,
                                                   type: .Network,
                                                   error: error)
                handler(nil, nil, errorMessage)
            }

            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                do {
                    let currentWeather = try JSONDecoder().decode(Forecast.self, from: data)

                    handler(currentWeather, city, nil)
                } catch {
                    let errorMessage = APIErrorMessage(brokenUrl: url,
                                                       data: data,
                                                       type: .Parsing,
                                                       error: nil)

                    handler(nil, nil, errorMessage)
                }
            } else {
                let errorMessage = APIErrorMessage(brokenUrl: url,
                                                   data: data,
                                                   type: .Parsing,
                                                   error: nil)

                handler(nil, nil, errorMessage)
            }


        }.resume()

    }
}

