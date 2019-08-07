//
//  APIErrorMessage.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 07/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

struct APIErrorMessage {

    enum ErrorType: String { case Parsing, Data, Network }

    var brokenUrl: URL?
    var data: Data?
    var type: ErrorType
    var errorMessage: String?

    init(brokenUrl: URL?, data: Data? = nil, type: ErrorType, error: Error?) {
        self.brokenUrl = brokenUrl
        self.data = data
        self.type = type
        self.errorMessage = error?.localizedDescription
    }

    func body() -> String {
        return """
        >>>문제 발생:bomb:\n
        URL: \(self.brokenUrl?.absoluteString ?? "none")\n
        Code: \((self.data?.prettyPrintedJSONString) ?? "none")\n
        type: \(self.type.rawValue)\n
        ErrorMessage: \(errorMessage ?? "none")\n
        """
    }
}
