//
//  UIButton+Extension.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 30/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import UIKit

extension UIButton {
    static func addBackButton(color: UIColor? = nil, btnImage: UIImage, onView view: UIView) -> UIButton {
        let btnWandH = CGFloat(30)
        let topConstraintY = CGFloat(40)
        let leadingConstraintX = CGFloat(16)
        let buttonImgColored = btnImage.maskWithColor(color: color ?? .black)
        let btn = UIButton()
        view.addSubview(btn)
        
        btn.setImage(buttonImgColored, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: btn, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: leadingConstraintX)
        let topConstraint = NSLayoutConstraint(item: btn, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: topConstraintY)
        let widthConstraint = NSLayoutConstraint(item: btn, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: btnWandH)
        let heightConstraint = NSLayoutConstraint(item: btn, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: btnWandH)
        view.addConstraints([leadingConstraint, topConstraint, widthConstraint, heightConstraint])
        
        return btn
    }
}
