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

        if let imageData = cacheImageData(at: imageSavingPath) {
            handler(imageData)
        } else {
            ImageSetter.download(iconKey: iconKey, handler: handler)
        }
    }


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


        urlSession.downloadTask(with: sessionUrl) {(tempLoation, response, error) in

            if let _ = error {
                handler(nil)
            }

            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let tempLoation = tempLoation {
                ImageSetter.moveItem(fromPath: tempLoation, destinationPath: imageSavingPath, handler: handler)
            }
        }.resume()
    }


    private class func moveItem(fromPath: URL, destinationPath: URL, handler: @escaping((Data?) -> Void)) {
        if FileManager.default.fileExists(atPath: destinationPath.path) {
            do {
                try FileManager.default.removeItem(atPath: destinationPath.path)
            } catch {
                handler(nil)
            }
        }
        do {
            try FileManager.default.moveItem(at: fromPath, to: destinationPath)
            let data = try Data(contentsOf: destinationPath)
            handler(data)
        } catch {
            handler(nil)
        }
    }

}







