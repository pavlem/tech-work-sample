//
//  testDaresayTests.swift
//  testDaresayTests
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import XCTest
@testable import testDaresay

class testDaresayTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

// MARK: - CurrentWeatherViewModel
extension testDaresayTests {
    func testGetTemperature() {
        XCTAssert(CurrentWeatherViewModel.getTemperature(temp: 27.0, isMetric: true) == "27 º", "🍊🍊, testGetTemperature not ok")
        XCTAssert(CurrentWeatherViewModel.getTemperature(temp: 27.0, isMetric: false) == "81 ºF", "🍊🍊, testGetTemperature not ok")
        XCTAssert(CurrentWeatherViewModel.getTemperature(temp: 127.0, isMetric: true) == "127 º", "🍊🍊, testGetTemperature not ok")
        XCTAssert(CurrentWeatherViewModel.getTemperature(temp: 127.0, isMetric: false) == "261 ºF", "🍊🍊, testGetTemperature not ok")
        XCTAssert(CurrentWeatherViewModel.getTemperature(temp: -73.0, isMetric: true) == "-73 º", "🍊🍊, testGetTemperature not ok")
        XCTAssert(CurrentWeatherViewModel.getTemperature(temp: -73.0, isMetric: false) == "-99 ºF", "🍊🍊, testGetTemperature not ok")
    }
    
    func testGetTempInF() {
        XCTAssert(CurrentWeatherViewModel.getTempInF(fromTemp: 300.0) == 572, "🍊🍊, testGetTempInF not ok")
        XCTAssert(CurrentWeatherViewModel.getTempInF(fromTemp: 30.0) == 86, "🍊🍊, testGetTempInF not ok")
        XCTAssert(CurrentWeatherViewModel.getTempInF(fromTemp: 200.0) == 392, "🍊🍊, testGetTempInF not ok")
    }
    
    func testGetTempInC() {
        XCTAssert(CurrentWeatherViewModel.getTempInC(fromTemp: 300.0) == 300, "🍊🍊, testGetTempInC not ok")
        XCTAssert(CurrentWeatherViewModel.getTempInC(fromTemp: 400.0) == 400, "🍊🍊, testGetTempInC not ok")
        XCTAssert(CurrentWeatherViewModel.getTempInC(fromTemp: 200.0) == 200, "🍊🍊, testGetTempInC not ok")
    }
    
    func testGetWeatherIconURLString() {
        XCTAssert(CurrentWeatherViewModel.getWeatherIconURLString("1a") == "http://openweathermap.org/img/wn/1a@2x.png", "🍊🍊, getWeatherIconURLString not ok")
        
        XCTAssert(CurrentWeatherViewModel.getWeatherIconURLString("5d") == "http://openweathermap.org/img/wn/5d@2x.png", "🍊🍊, getWeatherIconURLString not ok")
        XCTAssert(CurrentWeatherViewModel.getWeatherIconURLString(nil) == nil, "🍊🍊, getWeatherIconURLString not ok")
    }
    
    func testGetWindSpeed() {
        let sm1 = CurrentWeatherViewModel.getWindSpeed(1.5, isMetric: true)
        let sm2 = CurrentWeatherViewModel.getWindSpeed(100.0, isMetric: true)
        let sm3 = CurrentWeatherViewModel.getWindSpeed(30, isMetric: true)
        let si1 = CurrentWeatherViewModel.getWindSpeed(1.5, isMetric: false)
        let si2 = CurrentWeatherViewModel.getWindSpeed(100.0, isMetric: false)
        let si3 = CurrentWeatherViewModel.getWindSpeed(30, isMetric: false)
        
        XCTAssert(sm1 == "1.5 m/s", "🍊🍊, testGetWindSpeed not ok")
        XCTAssert(sm2 == "100.0 m/s", "🍊🍊, testGetWindSpeed not ok")
        XCTAssert(sm3 == "30.0 m/s", "🍊🍊, testGetWindSpeed not ok")
        XCTAssert(si1 == "3.36 MPH", "🍊🍊, testGetWindSpeed not ok")
        XCTAssert(si2 == "223.7 MPH", "🍊🍊, testGetWindSpeed not ok")
        XCTAssert(si3 == "67.11 MPH", "🍊🍊, testGetWindSpeed not ok")
    }
    
    func testWeatherVM() {
        MOCHelper.fetchWeather { (isFetched, currentWeather) in
            guard let weather = currentWeather else { return }
            let weatherVM = CurrentWeatherViewModel(weather: weather)

            // stored properties
            XCTAssert(weatherVM.coordinates == "Selected Latitute And Longitude Are: -15.79, -48.09", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.shortDescription == "Clouds", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.generalDescription == "Broken Clouds", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.iconUrl == "http://openweathermap.org/img/wn/04d@2x.png", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.tInC == "26 º", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.tInCMax == "26 º", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.tInCMin == "25 º", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.tInF == "78 ºF", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.tInFMax == "79 ºF", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.tInFMin == "77 ºF", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.pressure == "Pressure: 1018.0 hPa", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.humidity == "Humidity: 61.0 %", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.windSpeedMetric == "4.1 m/s", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.windSpeedImperial == "9.17 MPH", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.windSpeedDirection == "Wind Speed Direction: 90.0 º", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.clouds == "Cloudiness: None", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.cityName == "City Name: Brasilia", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.sunrise == "Sunrise: 09:36", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.sunset == "Sunset: 22:15", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.timeZone == "Timezone: -03:00 From GMT", "🍊🍊, testWeatherVM not ok")

            // calculated properties
            XCTAssert(weatherVM.detailesDescription == "Today is Broken Clouds. Current temp: 26 º. High and Low are: 26 º, 25 º. Sunrise: 09:36h and Sunset: 22:15h.", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.countryDetails.countryName == "Brazil", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.countryDetails.countryFlag == "🇧🇷", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.lowestTempD == "Lowest temp: 25 º", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.highestTempD == "Highest temp: 26 º", "🍊🍊, testWeatherVM not ok")
            XCTAssert(weatherVM.currentTD == "Current temp: 26 º", "🍊🍊, testWeatherVM not ok")
        }
    }
}
