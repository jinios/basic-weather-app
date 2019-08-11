//
//  DataSetter.swift
//  WeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

final class DataSetter {

    class func fetch<T: Decodable>(url: URL, index: Int?, type: T.Type, handler: @escaping ((Result<T>) -> Void)) {

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

}

enum Result<T: Decodable> {
    case success(T)
    case failure(Error?, APIErrorMessage?)
}
