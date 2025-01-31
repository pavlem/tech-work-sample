//  UIApplication+Extension.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 30/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    
    static var topNavigationViewController: UINavigationController? {
        return self.topPresentedViewController as? UINavigationController
    }
    
    static var topPresentedViewController: UIViewController? {
        return self.rootViewController.flatMap { UIViewController.topPresentedViewController($0) }
    }
    
    static var rootViewController: UIViewController? {
        get {
            return self.shared.delegate!.window!!.rootViewController
        }
        
        set {
            self.shared.delegate!.window!!.rootViewController = newValue
        }
    }
}

extension UIViewController {
    fileprivate static func topPresentedViewController(_ viewController: UIViewController) -> UIViewController {
        if let presentedViewController = viewController.presentedViewController {
            return UIViewController.topPresentedViewController(presentedViewController)
        }
        
        return viewController
    }
}
