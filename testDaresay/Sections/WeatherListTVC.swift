//
//  WeatherListTVC.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 30/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import UIKit

class WeatherListTVC: UITableViewController {
    
    // MARK: - API
    var currentWeatherViewModel: CurrentWeatherViewModel? {
        didSet {
            reloadUI()
        }
    }
    
    // MARK: - Properties
    // MARK: Outlets
    @IBOutlet weak var tableviewHeader: UIView!
    @IBOutlet weak var longerDescriptionLbl: UILabel!
    @IBOutlet weak var weatherStandardChooser: UISegmentedControl!
    // MARK: Vars
    private var weatherDataList: [String]?
    private var weatherVC: WeatherVC? {
        if let wVC = self.parent as? WeatherVC {
            return wVC
        }
        return nil
    }
    // MARK: Constants
    private let tableViewHeaderHeight = CGFloat(200)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTxt()
        setUI()
    }

    // MARK: - Helper
    private func setTxt() {
        weatherStandardChooser.setTitle("Metric".localized, forSegmentAt: MeasuringSystem.metric.rawValue)
        weatherStandardChooser.setTitle("Imperial".localized, forSegmentAt: MeasuringSystem.imperial.rawValue)
    }
    
    private func setUI() {
        longerDescriptionLbl.textColor = .white
        weatherStandardChooser.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        weatherStandardChooser.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        weatherStandardChooser.selectedSegmentTintColor = UIColor.black.withAlphaComponent(0.3)
        tableView.addTableFooterView(footerViewHeight: tableViewHeaderHeight, color: .clear)
    }
    
    private func reloadUI() {
        weatherVC?.temperatureLbl.text = currentWeatherViewModel?.currentT
        weatherDataList = currentWeatherViewModel?.weatherDataArray
        longerDescriptionLbl.text = currentWeatherViewModel?.detailesDescription
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func strandardOption(_ sender: UISegmentedControl) {
        switch MeasuringSystem(rawValue: sender.selectedSegmentIndex)! {
        case .metric:
            currentWeatherViewModel?.isMetric = true
            reloadUI()
        case .imperial:
            currentWeatherViewModel?.isMetric = false
            reloadUI()
        }
    }
}

// MARK: - UITableViewDataSource
extension WeatherListTVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherCell = tableView.dequeueReusableCell(withIdentifier: WeatherListCell.id, for: indexPath) as! WeatherListCell
        weatherCell.weatherData = WeatherListData(wData: weatherDataList?[indexPath.row])
        return weatherCell
    }
}

// MARK: - UIScrollViewDelegate
extension WeatherListTVC {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let wVC = weatherVC else { return }
        wVC.tempAndIcon.alpha = 1 - (scrollView.contentOffset.y / tableviewHeader.frame.size.height)
        
        if wVC.infoViewTopStartValue - scrollView.contentOffset.y < 0 {
            return
        } else {
            wVC.tvContainerTopC.constant = wVC.tvContainerTopStartValue - scrollView.contentOffset.y
            wVC.infoViewTopC.constant = wVC.infoViewTopStartValue - scrollView.contentOffset.y
        }
    }
}
