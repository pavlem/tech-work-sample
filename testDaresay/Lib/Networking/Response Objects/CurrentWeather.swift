//
//  ViewController.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case date = "dt"
        case sys
        case timezone
        case id
        case name
        case cod
    }
    
    let coord: CurrentWeatherCoordinates?
    let weather: [CurrentWeatherWeatherData]?
    let base: String?
    let main: CurrentWeatherMain?
    let visibility: Int?
    let wind: CurrentWeatherWind?
    let clouds: CurrentWeatherClouds?
    let date: Double?
    let sys: CurrentWeatherSys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
}
