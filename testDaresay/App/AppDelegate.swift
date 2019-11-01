//
//  AppDelegate.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Vars
    var window: UIWindow?
    
    // MARK: App lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setRootVC()
        return true
    }
}

// MARK: - Helper
extension AppDelegate {
    private func setRootVC() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: UIStoryboard.startVC)
    }
}
