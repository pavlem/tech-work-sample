//
//  MOCHelper.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

struct MOCHelper {
    
    static func fetchWeather(completion: @escaping (Bool, CurrentWeather?) -> Void) {
        let filePath = "weatherMOC"
        MOCHelper.loadJsonDataFromFile(filePath, completion: { data in
            if let json = data {
                do {
                    let estimate = try JSONDecoder().decode(CurrentWeather.self, from: json)
                    completion(true, estimate)
                }
                catch _ as NSError {
                    fatalError("Couldn't load data from \(filePath)")
                }
            }
        })
    }
    
    private static func loadJsonDataFromFile(_ path: String, completion: (Data?) -> Void) {
        if let fileUrl = Bundle.main.url(forResource: path, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl, options: [])
                completion(data as Data)
            } catch (let error) {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
