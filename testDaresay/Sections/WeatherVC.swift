//
//  WeatherVC.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 30/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import UIKit

class WeatherVC: BaseVC, Blurrable {

    // MARK: - API
    var currentWeatherViewModel: CurrentWeatherViewModel?
    var backgroundImg: UIImage?
    var infoViewTopStartValue = CGFloat(0.0)
    var tvContainerTopStartValue = CGFloat(0.0)
    
    // MARK: - Properties
    // MARK: Outlets
    @IBOutlet weak var infoViewTopC: NSLayoutConstraint!
    @IBOutlet weak var tvContainerTopC: NSLayoutConstraint!
    @IBOutlet weak var tempAndIcon: UIStackView!
    @IBOutlet weak var selectedAreaLbl: UILabel!
    @IBOutlet weak var weatherDescriptionLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var weatherImgView: UIImageView!
    // MARK: Vars
    private var dataTask: URLSessionDataTask?
    private var areaInfo: String {
        let city = currentWeatherViewModel?.city ?? ""
        let cName = currentWeatherViewModel?.countryDetails.countryName ?? ""
        let cFlag = currentWeatherViewModel?.countryDetails.countryFlag ?? ""
        
        if city.count == 0 {
            return cName + " " + cFlag
        }
        return city + ", " + cName + " " + cFlag
    }

    // MARK: - Overrides
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTxt()
        setUI()
        
        if let urlString =  currentWeatherViewModel?.iconUrl {
            fetchWeatherIcon(forUrlString: urlString) { [weak self] (imgData) in
                guard let `self` = self else { return }
                DispatchQueue.main.async() {
                    self.weatherImgView.image = UIImage(data: imgData)
                }
            }
        }
        
        infoViewTopStartValue = infoViewTopC.constant
        tvContainerTopStartValue = tvContainerTopC.constant
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dataTask?.cancel()
    }
    
    // MARK: - Actions
    @IBAction func popBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper
    private func fetchWeatherIcon(forUrlString urlString: String, success: @escaping (Data) -> Void)  {
        if let urlIcon = URL(string:  urlString) {
            getData(from: urlIcon) { data, response, error  in
                guard let data = data, error == nil else { return }
                success(data)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let dTask = URLSession.shared.dataTask(with: url, completionHandler: completion)
        self.dataTask = dTask
        dTask.resume()
    }
    
    private func setTxt() {
        temperatureLbl.text = currentWeatherViewModel?.currentT ?? ""
        selectedAreaLbl.text = areaInfo
        weatherDescriptionLbl.text = currentWeatherViewModel?.generalDescription ?? ""
    }
    
    private func setUI() {
        temperatureLbl.textColor = UIColor.white
        weatherDescriptionLbl.textColor = UIColor.white
        selectedAreaLbl.textColor = UIColor.white
        
        temperatureLbl.font = UIFont.boldSystemFont(ofSize: 50)
        weatherDescriptionLbl.font = UIFont.systemFont(ofSize: 17)
        selectedAreaLbl.font = UIFont.systemFont(ofSize: 17)

        if let weeatherListTVC = self.children.first as? WeatherListTVC {
            weeatherListTVC.currentWeatherViewModel = self.currentWeatherViewModel
        }
        
        blurrBackground()

        let imageView = UIImageView(frame: UIApplication.keyWindow?.frame ?? self.view.frame)
        imageView.image = backgroundImg
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        addBackButton(color: .white)
        self.navigationController?.navigationBar.isHidden = true
    }
}
