//
//  Extensions.swift
//  WeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}

enum Time {
    case second(Double)
    case minute(Double)
    case hour(Double)

    var timeIntervalValue: Double {
        switch self {
        case let .second(value): return value
        case let .minute(value): return value * 60
        case let .hour(value): return value * 3600
        }
    }
}

extension Date {

    func convertToString(format: String) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func isFuture(from: Date) -> Bool {
        let result = self.convertKST().timeIntervalSinceNow - from.timeIntervalSinceNow
        return result > 0 ? true : false
    }

    func convertKST() -> Date {
        return self.toStringKST().convertDate!
    }

    func convertHour() -> Int {
        return Int(self.convertToString(format: "HH")) ?? 0
    }

    func convertMinute() -> Int {
        return Int(self.convertToString(format: "mm")) ?? 0
    }

    func convertAMPM() -> String {
        let hour = self.convertHour()
        return hour < 12 ? "오전" : "오후"
    }

    func convertAMPMHHMM(includeMinute: Bool) -> String {
        let standard = 12
        var result = self.convertAMPM()

        if self.convertHour() > standard {
            result.append(" \(self.convertHour()-standard)")
        } else {
            result.append(" \(self.convertHour())")
        }

        if includeMinute {
            result.append(":\(self.convertMinute())")
        }
        return result
    }

    func dayOfWeek(isShort: Bool = false) -> String {
        let weekDay = self.convertToString(format: "e")

        var result : String = ""
        switch weekDay {
        case "1": result = "일"
        case "2": result = "월"
        case "3": result = "화"
        case "4": result = "수"
        case "5": result = "목"
        case "6": result = "금"
        case "7": result = "토"
        default: result = ""
        }

        return isShort ? result : "\(result)요일"
    }

    func dayOfWeek() -> Int {
        let weekDay = self.convertToString(format: "e")
        return Int(weekDay) ?? 0
    }

    func toString(formatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    func toStringKST(formatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        return self.toString(formatter: formatter)
    }

    func toStringUTC(formatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }


}

extension String {
    var convertDate: Date? {
        get {
            let formatter: DateFormatter = DateFormatter()
            formatter.timeZone = TimeZone.init(abbreviation: "KST")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            guard let date = formatter.date(from: self) else { return nil }
            return date
        }
    }

    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone.init(abbreviation: "KST")
        formatter.dateFormat = format


        guard let date = formatter.date(from: self) else { return nil }
        return date
    }


}

extension UIAlertController {
    class func make(message: String = "죄송합니다😰 문제가 발생했습니다. \n잠시 후 다시 확인해주세요.") -> UIAlertController {
        let alert = UIAlertController(title: nil,
                                      message: message.description,
                                      preferredStyle: .alert)
        return alert
    }

}


struct SlackWebhook {
    enum Keyword: String {
        case url = "https://hooks.slack.com/services/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"
        case httpPostRequest = "POST"
        case dataType = "application/json"
        case headerField = "Content-Type"
    }

    static func fire(message: String? = nil) {

        guard let url = URL(string: SlackWebhook.Keyword.url.rawValue) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(SlackWebhook.Keyword.dataType.rawValue, forHTTPHeaderField: SlackWebhook.Keyword.headerField.rawValue)

        var payload: [String:String] = [:]
        payload["text"] = message ?? "none"
        payload["icon_emoji"] = self.selectRandomEmoji()

        guard let httpBody = try? JSONSerialization.data(withJSONObject: payload, options: []) else { return }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request).resume()

    }

    private static func selectRandomEmoji() -> String {
        let emoji = [":smiling_imp:", ":hankey::ghost:", ":skull_and_crossbones:", ":scream_cat:", ":boom:", ":scream:", ":exploding_head:", ":face_with_symbols_on_mouth:"]
        return emoji.randomElement() ?? ":exploding_head:"
    }

}

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
