//  UIImage+Icons.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 30/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum SGAlert {
        static var negativeImg: UIImage { return UIImage(named: "sgAlertNegativeImg")! }
        static var positiveImg: UIImage { return UIImage(named: "sgAlertPositiveImg")! }
    }
    
    static var backBtnImg: UIImage { return UIImage(named: "backImg")! }
}
