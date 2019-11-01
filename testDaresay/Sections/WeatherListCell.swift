//
//  WeatherListCell.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 30/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import UIKit

struct WeatherListData {
    let wData: String?
}

class WeatherListCell: UITableViewCell {
    
    // MARK: - API
    var weatherData: WeatherListData? {
        willSet {
            updateUI(withWeatherData: newValue)
        }
    }
    
    // MARK: - Properties
    // MARK: Outlets
    @IBOutlet weak var weatherInfoLbl: UILabel!
    // MARK: Constants
    static let id = "WeatherListCell_ID"

    // MARK: - Helper
    private func updateUI(withWeatherData weatherData: WeatherListData?) {
        guard let inputString = weatherData?.wData else { return }
        let attributedString = getAttributedString(inputString: inputString)
        weatherInfoLbl.attributedText = attributedString
    }
    
    private func setUI() {
        selectionStyle = .none
        weatherInfoLbl.textColor = .white
        weatherInfoLbl.font = UIFont.systemFont(ofSize: 17)
    }
    
    private func getAttributedString(inputString: String) -> NSMutableAttributedString? {
        guard inputString.contains(":") else { return nil }
        let stringArr = inputString.components(separatedBy: ":")
        let firstPart = stringArr[0] + ":"
        var secondPart = stringArr[1]
        if stringArr.count == 3 {
            secondPart.append(":")
            secondPart.append(stringArr[2])
        }
        
        let fontB = UIFont.boldSystemFont(ofSize: 19)
        let fontR = UIFont.systemFont(ofSize: 17)
        let txtColor = UIColor.white
        
        let attributesB: [NSAttributedString.Key: Any] = [
            .font: fontB,
            .foregroundColor: txtColor,
        ]
        
        let attributesR: [NSAttributedString.Key: Any] = [
            .font: fontR,
            .foregroundColor: txtColor,
        ]
        
        let firstPartAtt = NSAttributedString(string: firstPart, attributes: attributesR)
        let secondPartAtt = NSAttributedString(string: secondPart, attributes: attributesB)
        let completeString = NSMutableAttributedString()
        completeString.append(firstPartAtt)
        completeString.append(secondPartAtt)
        return completeString
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
}
