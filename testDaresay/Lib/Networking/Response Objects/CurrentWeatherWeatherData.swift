//
//  CurrentWeatherWeatherData.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 01/11/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

public struct CurrentWeatherWeatherData: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}
