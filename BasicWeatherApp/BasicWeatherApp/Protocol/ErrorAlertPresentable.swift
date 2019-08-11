//
//  ErrorAlertPresentable.swift
//  BasicWeatherApp
//
//  Created by YOUTH2 on 07/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import UIKit

protocol ErrorAlertPresentable: class {
    func sendErrorAlert(error: APIErrorMessage)
}
