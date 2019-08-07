//
//  SlackWebhook.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 07/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import Foundation

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
