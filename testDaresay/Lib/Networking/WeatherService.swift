//
//  ViewController.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

class WeatherService: WeatherServerService {
    
    let shouldPrintLog = false
    
    func loadWeather(weatherCoordinatesReq: WeatherCoordinatesReq, completion: @escaping (CurrentWeather?, ServiceError?) -> ()) -> URLSessionDataTask? {
        
        let params = WeatherCoordinatesReq.bodyParameters(forWeatherCoordinatesReq: weatherCoordinatesReq)
        
        return loadWeather(withParams: params) { (currentWeather, serviceErr) in
            completion(currentWeather, serviceErr)
        }
    }
    
    func loadWeather(withCityName cityName: String, completion: @escaping (CurrentWeather?, ServiceError?) -> ()) -> URLSessionDataTask? {
        
        let params = WeatherCoordinatesReq.bodyParameters(forCityName: cityName)
        
        return loadWeather(withParams: params) { (currentWeather, serviceErr) in
            completion(currentWeather, serviceErr)
        }
    }
    
    private func loadWeather(withParams params: JSON?, completion: @escaping (CurrentWeather?, ServiceError?) -> ()) -> URLSessionDataTask? {
        
        return client.load(path: ServiceEndpoint.weather, method: .get, params: params, headers: nil, shouldPrintLog: shouldPrintLog, completion: { (jsonObject, data, error) in
            
            do {
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                
                let currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                completion(currentWeather, error)
            } catch let jsonErr {
                let jsonErrString = String(describing: jsonErr)
                completion(nil, ServiceError.custom(jsonErrString))
            }
        })
    }
}
