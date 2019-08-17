//
//  ErrorAlertPresentable.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 07/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

protocol ErrorAlertPresentable: UIViewController {
    func sendErrorAlert(error: APIErrorMessage)
}

extension ErrorAlertPresentable {

    func sendErrorAlert(error: APIErrorMessage) {
        let action = UIAlertAction(title: "Done", style: .default) { _ in
            SlackWebhook.fire(message: error.body())
        }
        let alert = UIAlertController.make(action: action)
        self.present(alert, animated: true, completion: nil)
    }

}
