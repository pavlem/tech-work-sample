//
//  ViewController.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import UIKit
import MapKit

class StartVC: BaseVC {
    
    // MARK: - Properties
    // MARK: Outlets
    @IBOutlet weak var findCityWeatherBtn: UIButton!
    @IBOutlet weak var showCurrentWeatherBtn: UIButton!
    @IBOutlet weak var enterCityTxtFld: UITextField!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarHeightCsrt: NSLayoutConstraint!
    @IBOutlet weak var topBarTopCsrt: NSLayoutConstraint!
    
    // MARK: Vars
    private var dataTask: URLSessionDataTask?
    private var selectedLocationInfo: CLPlacemark?
    private var foundLocation: CLLocation? {
        willSet {
            guard let location = newValue else { return }
            mapVC?.setRegionFor(location: location, animated: true)
        }
    }
    
    // MARK: Calculated
    private var mapVC: MapVC? {
        return children.last as? MapVC
    }
    
    // MARK: Constants
    private let topBarViewH = CGFloat(88)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTxt()
        setUI()
        setDelegates()
        startMonitoringForLocation()
    }
    
    override func online() {
        super.online()
        
        LocationEngine.shared.startMonitoringForLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.dataTask?.cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setTopBarHeightAndYPosition()
    }
    
    // MARK: - Action
    @IBAction func findCity(_ sender: UIButton?) {
        guard ReachabilityHelper.isThereInternetConnection else {
            showNoInternetAlert()
            return
        }

        guard let cityName = enterCityTxtFld.text else { return }
        enterCityTxtFld.endEditing(true)

        guard cityName.count > 1 else {
            showDaresayAlert(text: "CityNameNotOk".localized, isPositiveAlert: false, isDismissedAfterTimeout: true)
            return
        }

        BlockingScreen.start()
        fetchWeatherDataWith(cityName: cityName)
    }
    
    @IBAction func showCurrentWeatherInfo(_ sender: UIButton) {
        guard ReachabilityHelper.isThereInternetConnection else {
            showNoInternetAlert()
            return
        }
        
        guard let foundLocation = self.foundLocation else {
            showDaresayAlert(text: "NoLocationFound".localized, isPositiveAlert: false)
            return
        }
        
        enterCityTxtFld.text = ""
        mapVC?.setRegionFor(location: foundLocation, animated: false)
        dataTask?.cancel()
        enterCityTxtFld.endEditing(true)
        BlockingScreen.start()

        let center = CLLocationCoordinate2D(latitude: foundLocation.coordinate.latitude, longitude: foundLocation.coordinate.longitude)
        let weatherCoordinatesReq = WeatherCoordinatesReq(lon: String(center.longitude), lat: String(center.latitude))

        fetchWeatherDataWithCoordinates(weatherCoordinatesReq: weatherCoordinatesReq)
    }

    // MARK: - Helper
    private func fetchWeatherDataWith(cityName: String) {
        dataTask = WeatherService().loadWeather(withCityName: cityName, completion: { [weak self] (weather, error) in
            guard let `self` = self else { return }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    BlockingScreen.stop()
                    self.showDaresayAlert(text: "CityNameNotFound".localized, isPositiveAlert: false, isDismissedAfterTimeout: true)
                }
                return
            }
            
            self.openWeatherVC(currentWeather: weather)
        })
    }
    
    private func fetchWeatherDataWithCoordinates(weatherCoordinatesReq: WeatherCoordinatesReq) {
        dataTask = WeatherService().loadWeather(weatherCoordinatesReq: weatherCoordinatesReq, completion: { [weak self] (weather, error) in
            guard let `self` = self else { return }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    BlockingScreen.stop()
                    self.showDaresayAlert(text: "CurrenLocationNotFound".localized, isPositiveAlert: false, isDismissedAfterTimeout: true)
                }
                return
            }
            
            self.openWeatherVC(currentWeather: weather)
        })
    }
    
    private func startMonitoringForLocation() {
        LocationEngine.shared.startMonitoringForLocation()
    }
    
    private func openWeatherVC(currentWeather: CurrentWeather?) {
        guard let currentWeather = currentWeather else { return }
        DispatchQueue.main.async {
            BlockingScreen.stop()
            let weatherVC = UIStoryboard.weatherVC
            weatherVC.currentWeatherViewModel = CurrentWeatherViewModel(weather: currentWeather)
            weatherVC.backgroundImg = self.view.takeScreenshot()
            self.navigationController?.customPush(weatherVC)
        }
    }
    
    private func setTopBarHeightAndYPosition() {
        topBarTopCsrt.constant = 0
        topBarHeightCsrt.constant = topBarViewH + view.safeAreaInsets.top
    }
    
    private func setTxt() {
        findCityWeatherBtn.setTitle("Find".localized, for: .normal)
        showCurrentWeatherBtn.setTitle("ShowWeatherForCurrentLocation".localized, for: .normal)
        enterCityTxtFld.placeholder = "EnterCityLocation".localized
    }
    
    private func setUI() {
        topBarView.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = topBarView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        topBarView.insertSubview(blurEffectView, at: 0)
        
        showCurrentWeatherBtn.setTitleColor(.white, for: .normal)
        findCityWeatherBtn.setTitleColor(.white, for: .normal)
        enterCityTxtFld.textColor = .black
    }
    
    private func setDelegates() {
        mapVC?.delegate = self
        enterCityTxtFld.delegate = self
        LocationEngine.shared.delegate = self
    }
}

// MARK: - MapVCProtocol
extension StartVC: MapVCProtocol {
    
    func mapDragged() {
        enterCityTxtFld.endEditing(true)
    }
    
    func coordinateChosen(point: CLLocationCoordinate2D, placemark: CLPlacemark) {
        guard ReachabilityHelper.isThereInternetConnection else {
            showNoInternetAlert()
            return
        }
        
        selectedLocationInfo = placemark
        enterCityTxtFld.endEditing(true)
        BlockingScreen.start()
        fetchWeatherDataWithCoordinates(weatherCoordinatesReq: WeatherCoordinatesReq(lon: String(point.longitude), lat: String(point.latitude)))
    }
}

// MARK: - UITextFieldDelegate
extension StartVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        findCity(nil)
        resignFirstResponder()
        return true
    }
}

// MARK: - LocationEngineProtocol
extension StartVC: LocationEngineProtocol {
    func locationFound(location: CLLocation) {
        foundLocation = location
    }
}
