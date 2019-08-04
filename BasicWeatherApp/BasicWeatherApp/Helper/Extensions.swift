//
//  Extensions.swift
//  WeatherApp
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}

extension Date {

    func convertToString(format: String) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        return formatter.string(from: self)
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

    func convertAMPMHHMM() -> String {
        let standard = 12
        var result = self.convertAMPM()

        if self.convertHour() > standard {
            result.append(" \(self.convertHour()-standard)")
        } else {
            result.append(" \(self.convertHour())")
        }

        result.append(":\(self.convertMinute())")
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

}

extension String {
    var convertDate : Date? {
        get {
            let formatter: DateFormatter = DateFormatter()
            formatter.timeZone = TimeZone.init(abbreviation: "KST")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            guard let date = formatter.date(from: self) else { return nil }
            return date
        }
    }

}
