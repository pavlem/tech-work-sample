//
//  CurrentWeatherSys.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 01/11/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

public struct CurrentWeatherSys: Codable {
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String?
    let sunrise: Double?
    let sunset: Double?
}
