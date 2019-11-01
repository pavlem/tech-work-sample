//
//  CurrentWeatherMain.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 01/11/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

public struct CurrentWeatherMain: Codable {
    let temp: Double?
    let pressure: Double?
    let humidity: Double?
    let temp_min: Double?
    let temp_max: Double?
    let grnd_level: Double?
    let sea_level: Double?
}
