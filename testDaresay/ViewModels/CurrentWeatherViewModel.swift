//
//  CurrentWeatherViewModel.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 30/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation
import UIKit
//import Entities

struct CurrentWeatherViewModel {
    
    // MARK: - Properties
    let coordinates: String?
    let shortDescription: String?
    let generalDescription: String?
    let iconUrl: String?
    var tInC: String?
    var tInCMax: String?
    var tInCMin: String?
    var tInF: String?
    var tInFMax: String?
    var tInFMin: String?
    let pressure: String?
    let humidity: String?
    let seaLlvPressure: String?
    let groundLlvPressure: String?
    let windSpeedMetric: String?
    let windSpeedImperial: String?
    let windSpeedDirection: String?
    let clouds: String?
    let cityName: String?
    let city: String?
    let dateForDataRetreived: String?
    let sunrise: String?
    let sunset: String?
    let countryCode: String?
    let timeZone: String?
    var isMetric = true
    
    // MARK: Computed
    var detailesDescription: String {
        var genDescr = ""
        if let genDescription = self.generalDescription {
            genDescr = "Today".localized + " " + genDescription + "."
        }
        
        var temp = ""
        if let curT = self.currentT {
            temp = " " + "CurrentT".localized + " " + curT + "."
        }
        
        var highLow = ""
        if let hightT = self.highestTemp, let lowT = self.lowestTemp {
            highLow = " " + "HighLow".localized + " " + hightT + ", " + lowT + "."
        }
        
        var sunriseSunset = ""
        if let sunR = self.sunrise, let sunS = self.sunset {
            sunriseSunset = " " + sunR + "h" + " and " + sunS + "h" + "."
        }

        return genDescr + temp + highLow + sunriseSunset
    }
    
    var countryDetails: (countryName: String?, countryFlag: String?) {
        let countryDetails = CurrentWeatherViewModel.getCountryNameAndFlag(fromCode: self.countryCode)
        return (countryDetails.countryName, countryDetails.countryFlag)
    }
    
    var currentT: String? {
        if isMetric {
            return self.tInC
        } else {
            return self.tInF
        }
    }
    
    var highestTemp: String? {
        if isMetric {
            return self.tInCMax
        } else {
            return self.tInFMax
        }
    }
    
    var lowestTemp: String? {
        if isMetric {
            return self.tInCMin
        } else {
            return self.tInFMin
        }
    }
    
    var lowestTempD: String? {
        if isMetric {
            return "LowestT".localized + " " + self.tInCMin!
        } else {
            return "LowestT".localized + " " + self.tInFMin!
        }
    }
    
    var highestTempD: String? {
        if isMetric {
            return "HighestT".localized + " " + self.tInCMax!
        } else {
            return "HighestT".localized + " " + self.tInFMax!
        }
    }
    
    var currentTD: String? {
        if isMetric {
            return "CurrentT".localized + " " + self.tInC!
        } else {
            return "CurrentT".localized + " " + self.tInF!
        }
    }
    
    var windSpeedD: String? {
        if isMetric {
            return "WindSpeed".localized + " " + self.windSpeedMetric!
        } else {
            return "WindSpeed".localized + " " + self.windSpeedImperial!
        }
    }

    // MARK: - Inits
    init(weather: CurrentWeather) {
        self.coordinates = CurrentWeatherViewModel.getCordinates(lat: weather.coord?.lat, long: weather.coord?.lon)
        self.shortDescription = weather.weather?.first?.main
        self.generalDescription = weather.weather?.first?.description?.capitalized
        
        self.tInC = CurrentWeatherViewModel.getTemperature(temp: weather.main?.temp, isMetric: true)
        self.tInF =  CurrentWeatherViewModel.getTemperature(temp: weather.main?.temp, isMetric: false)
        self.tInCMax = CurrentWeatherViewModel.getTemperature(temp: weather.main?.temp_max, isMetric: true)
        self.tInCMin = CurrentWeatherViewModel.getTemperature(temp: weather.main?.temp_min, isMetric: true)
        self.tInFMax = CurrentWeatherViewModel.getTemperature(temp: weather.main?.temp_max, isMetric: false)
        self.tInFMin = CurrentWeatherViewModel.getTemperature(temp: weather.main?.temp_min, isMetric: false)
        
        self.iconUrl = CurrentWeatherViewModel.getWeatherIconURLString(weather.weather?.first?.icon)
        self.pressure = CurrentWeatherViewModel.get(pressure: weather.main?.pressure)
        self.humidity = CurrentWeatherViewModel.get(humidity: weather.main?.humidity)
        self.seaLlvPressure = CurrentWeatherViewModel.get(seaLvlPressure: weather.main?.sea_level)
        self.groundLlvPressure = CurrentWeatherViewModel.get(groundLlvPressure: weather.main?.grnd_level)
        
        self.windSpeedMetric = CurrentWeatherViewModel.getWindSpeed(weather.wind?.speed, isMetric: true)
        self.windSpeedImperial = CurrentWeatherViewModel.getWindSpeed(weather.wind?.speed, isMetric: false)
        self.windSpeedDirection = CurrentWeatherViewModel.get(windSpeedDirection: weather.wind?.deg)
        
        self.clouds = CurrentWeatherViewModel.getCloudiness(weather.clouds?.all)?.capitalized
        self.cityName = CurrentWeatherViewModel.get(cityName: weather.name)
        self.city = weather.name
        self.dateForDataRetreived = CurrentWeatherViewModel.getDateString(weather.date)
        self.sunset = CurrentWeatherViewModel.getSunset(weather.sys?.sunset)
        self.sunrise = CurrentWeatherViewModel.getSunrise(weather.sys?.sunrise)
        self.timeZone = "Timezone".localized + " " + (CurrentWeatherViewModel.getTimeZoneOffset(offestInSec: weather.timezone) ?? "") + " " + "FromGMT".localized
        self.countryCode = weather.sys?.country
    }
}

// MARK: - Helper
extension CurrentWeatherViewModel {
    
    static func getCountryNameAndFlag(fromCode countryCode: String?) -> (countryName: String?, countryFlag: String?) {
        guard let countryCode = countryCode else { return (nil, nil) }
        if let countryCode = CountryCodes.with(countryLabel: countryCode) {
            return (countryCode.country, countryCode.flag)
        }
        return (nil, nil)
    }
    
    static func getTimeZoneOffset(offestInSec: Int?) -> String? {
        guard let offset = offestInSec else { return nil }
        let hours = offset/3600
        let minutes = abs(offset/60) % 60
        return String(format: "%+.2d:%.2d", hours, minutes)
    }

    static func getDateString(_ unixDate: Double?) -> String? {
        guard let unixTimestamp = unixDate else { return nil }
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    static func getTimeString(_ unixDate: Double?) -> String? {
        guard let unixTimestamp = unixDate else { return nil }
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    static func getSunset(_ unixDate: Double?) -> String? {
        guard let str = getTimeString(unixDate) else { return nil }
        return "Sunset".localized + " " + str
    }

    static func getSunrise(_ unixDate: Double?) -> String? {
        guard let str = getTimeString(unixDate) else { return nil }
        return "Sunrise".localized + " " + str
    }
    
    static func get(cityName: String?) -> String? {
        guard let cityName = cityName else { return nil }
        return "CityName".localized + " " + cityName
    }

    static func getCloudiness(_ cloudiness: Int?) -> String? {
        guard let cloudiness = cloudiness else { return nil }
        return "Cloudiness".localized + " " + (cloudiness == 1 ? "Complete".localized : "none".localized)
    }
    
    static func getCordinates(lat: Double?, long: Double?) -> String? {
        guard let latitude = lat else { return nil }
        guard let longitude = long else { return nil }
        return "LatAndLongAre".localized + " " + String(latitude) + ", " + String(longitude)
    }
    
    static func getTemperature(temp: Double?, isMetric: Bool) -> String? {
        guard let temp = temp else { return nil }
        if isMetric {
            return String(CurrentWeatherViewModel.getTempInC(fromTemp: temp)) + " º"
        }
        return String(CurrentWeatherViewModel.getTempInF(fromTemp: temp)) + " ºF"
    }
    
    static func getTempInF(fromTemp temp: Double) -> Int {
        let doubleValue = (temp * (9/5) + 32).rounded(toPlaces: 0)
        let intValue = Int(doubleValue)
        return intValue
    }

    static func getTempInC(fromTemp temp: Double) -> Int {
        let doubleValue = (temp).rounded(toPlaces: 0)
        let intValue = Int(doubleValue)
        return intValue
    }

    static func getWeatherIconURLString(_ icon: String?) -> String? {
        guard let icon = icon else { return nil }
        return "http://openweathermap.org/img/wn/" + icon + "@2x.png"
    }
    
    static func get(pressure: Double?) -> String? {
        guard let pressure = pressure else { return nil }
        return "PressureIs".localized + " " + String(pressure)  + " hPa"
    }
    
    static func get(humidity: Double?) -> String? {
        guard let humidity = humidity else { return nil }
        return "HumidityIs".localized + " " + String(humidity) + " %"
    }
    
    static func get(seaLvlPressure: Double?) -> String? {
        guard let seaLvlPressure = seaLvlPressure else { return nil }
        return "SeaLvlPressureIs".localized + " " + String(seaLvlPressure) + " hPa"
    }
    
    static func get(groundLlvPressure: Double?) -> String? {
        guard let groundLlvPressure = groundLlvPressure else { return nil }
        return "GroundLlvPressureIs".localized + " " + String(groundLlvPressure) + " hPa"
    }
    
    static func getWindSpeed(_ windSpeed: Double?, isMetric: Bool) -> String? {
        guard let speed = windSpeed else { return nil }
        
        if isMetric {
            return String(speed.rounded(toPlaces: 2)) + " " + "MetersPerSecond".localized
        }
        return String((speed * 2.237).rounded(toPlaces: 2)) + " " + "MilesPerHour".localized
    }

    static func get(windSpeedDirection: Double?) -> String? {
        guard let windSpeedDirection = windSpeedDirection else { return nil }
        return "WindSpeedDirectionIs".localized + " " + String(windSpeedDirection) + " º"
    }
}

extension CurrentWeatherViewModel {
    var weatherDataArray: [String] {
        var dataArr = [String]()
        if let lowestT = lowestTempD {
            dataArr.append(lowestT)
        }
        
        if let highestT = highestTempD {
            dataArr.append(highestT)
        }
        
        if let currentT = currentTD {
            dataArr.append(currentT)
        }
        
        if let sunrise = self.sunrise {
            dataArr.append(sunrise)
        }
        
        if let sunset = self.sunset {
            dataArr.append(sunset)
        }
        
        if let pressure = self.pressure {
            dataArr.append(pressure)
        }
        
        if let humidity = self.humidity {
            dataArr.append(humidity)
        }
        
        if let seaLlvPressure = self.seaLlvPressure {
            dataArr.append(seaLlvPressure)
        }
        
        if let groundLlvPressure = self.groundLlvPressure {
            dataArr.append(groundLlvPressure)
        }
        
        if let windSpeedD = windSpeedD {
            dataArr.append(windSpeedD)
        }
        
        if let windSpeedDirection = self.windSpeedDirection {
            dataArr.append(windSpeedDirection)
        }
        
        if let timeZone = self.timeZone {
            dataArr.append(timeZone)
        }
        
        if let clouds = self.clouds {
            dataArr.append(clouds)
        }
        
        if let cityName = self.cityName {
            dataArr.append(cityName)
        }
        
        return dataArr
    }
}
