//
//  ViewController.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

class WeatherServerService {
    let client = WebClient(baseUrl: ServiceAPI.protocolFormat + ServiceAPI.serverURL)
}
