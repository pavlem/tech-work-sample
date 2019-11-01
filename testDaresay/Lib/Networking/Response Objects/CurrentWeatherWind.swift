//
//  CurrentWeatherWind.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 01/11/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

public struct CurrentWeatherWind: Codable {
    let speed: Double?
    let deg: Double?
    let gust: Double?
}
