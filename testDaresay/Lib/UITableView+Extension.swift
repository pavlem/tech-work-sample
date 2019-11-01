//
//  UITableView+Extension.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 30/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import UIKit

extension UITableView {
    
    func hideTableFooterView() {
        tableFooterView = UIView(frame: CGRect.zero)
        tableFooterView!.isHidden = true
    }
    
    func addTableFooterView(footerViewHeight: CGFloat = 20, color: UIColor = UIColor.darkGray) {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIApplication.keyWindow!.frame.width, height: footerViewHeight))
        footerView.backgroundColor = color
        tableFooterView = footerView
    }
    
    func addTableHeaderView(headerViewHeight: CGFloat = 20, color: UIColor = UIColor.darkGray) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIApplication.keyWindow!.frame.width, height: headerViewHeight))
        headerView.backgroundColor = color
        tableHeaderView = headerView
    }
}
