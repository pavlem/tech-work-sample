//
//  WeatherCoordinatesReq.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 29/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

struct WeatherCoordinatesReq {
    let lon: String
    let lat: String
}

extension WeatherCoordinatesReq {
    static func bodyParameters(forWeatherCoordinatesReq weatherCoordinatesReq: WeatherCoordinatesReq) -> [String: String] {
        return [
            "lat": weatherCoordinatesReq.lat,
            "lon": weatherCoordinatesReq.lon,
            "key": "62fc4256-8f8c-11e5-8994-feff819cdc9f"
        ]
    }
    
    static func bodyParameters(forCityName cityName: String) -> [String: String] {
        return [
            "q": cityName,
            "key": "62fc4256-8f8c-11e5-8994-feff819cdc9f"
        ]
    }
}
