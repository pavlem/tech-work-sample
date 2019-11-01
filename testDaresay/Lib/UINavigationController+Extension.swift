//
//  UINavigationController+Extension.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 30/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

import UIKit

struct NavigationTransitionDuration {
    static let push = 0.3
    static let pop = 0.8
}

extension UINavigationController {
    func customPush(_ viewController: UIViewController, animationOption: UIView.AnimationOptions? = nil, duration: Double? = nil) {
        self.pushViewController(viewController
            , animated: false)
        if let transitionView = self.view {
            UIView.transition(with:transitionView, duration: duration ?? NavigationTransitionDuration.push, options: animationOption ?? .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
    func customPop(isPopToRoot: Bool, animationOption: UIView.AnimationOptions? = nil, duration: Double? = nil) {
        if isPopToRoot {
            self.popToRootViewController(animated: true)
        } else {
            self.popViewController(animated: true)
        }
    }
}
