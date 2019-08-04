//
//  ImageSetter.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 05/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

class ImageSetter {

    class func fetch(iconKey: String, handler: @escaping ((Data?) -> Void)) {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let imageSavingPath = cacheURL.appendingPathComponent(iconKey)
        print("PATH: \(imageSavingPath)")

        if let imageData = cacheImageData(at: imageSavingPath) {
            handler(imageData)
        } else {
            ImageSetter.download(iconKey: iconKey, handler: handler)
        }
    }

    // 캐시된 이미지를 요청했을때 캐시데이터가 없으면 nil 리턴
    private class func cacheImageData(at imageSavingPath: URL) -> Data? {
        guard FileManager().fileExists(atPath: imageSavingPath.path) else { return nil }
        let existData = try? Data(contentsOf: imageSavingPath)
        return existData
    }

    private class func download(iconKey: String, handler: @escaping((Data?) -> Void)) {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let imageSavingPath = cacheURL.appendingPathComponent(iconKey)

        guard let baseUrl = KeyInfoLoader.loadValue(of: .IconBaseURL) else { return }

        var base = URL(string: baseUrl)
        base?.appendPathComponent("\(iconKey)@2x.png")

        let urlComponents = URLComponents(url: base!, resolvingAgainstBaseURL: true)

        guard let sessionUrl = urlComponents?.url else { return }
        let configure = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = 15
        let urlSession = URLSession(configuration: configure)

        LoadingIndicator.start()

        urlSession.downloadTask(with: sessionUrl) {(tempLoation, response, error) in

            if let error = error {
                print("FAIL TO DOWNLOAD ERROR: \(error)")
                handler(nil)
            }

            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let tempLoation = tempLoation {
                do {
                    try FileManager.default.moveItem(at: tempLoation, to: imageSavingPath)
                    let data = try Data(contentsOf: imageSavingPath)
                    handler(data)
                } catch {
                    print("FAIL TO CACHE FILE")
                    handler(nil)
                }
            }
            LoadingIndicator.stop()
        }.resume()

    }

}


