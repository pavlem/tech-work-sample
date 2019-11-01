//
//  UIStoryboard+Extension.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation
import UIKit


extension UIStoryboard {
    
    // MARK: - Storyboards
    static var main: UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }

    // MARK: - View controllers
    static var startVC: StartVC { return UIStoryboard.main.instantiateViewController(withIdentifier: "StartVC_ID") as! StartVC }
    static var mapVC: MapVC { return UIStoryboard.main.instantiateViewController(withIdentifier: "MapVC_ID") as! MapVC}
    
    
    static var weatherInfoVC: UIViewController { return UIStoryboard.main.instantiateViewController(withIdentifier: "WeatherInfoVC_ID")}
    
    
    
     static var weatherVC: WeatherVC { return UIStoryboard.main.instantiateViewController(withIdentifier: "WeatherVC_ID") as! WeatherVC }
}
