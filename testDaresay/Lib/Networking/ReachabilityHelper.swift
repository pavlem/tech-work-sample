//
//  ViewController.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

protocol ReachabilityHelperProtocol: class {
    func noInternet()
    func internetViaWiFi()
    func internetViaCell()
    func online()
}

extension ReachabilityHelperProtocol {
    func noInternet() {}
    func internetViaWiFi() {}
    func internetViaCell() {}
    func online() {}
}

class ReachabilityHelper {
    
    // MARK: - API
    static let shared = ReachabilityHelper()
    
    weak var delegate: ReachabilityHelperProtocol?
    
    let reachability = Reachability()!
    
    static var isThereInternetConnection: Bool {
        return ReachabilityHelper.shared.reachability.connection != .none
    }
    
    // MARK: - Inits
    init() {
        
        reachability.whenUnreachable = { _ in
            print("non reachability")
            self.delegate?.noInternet()
        }
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                self.delegate?.internetViaWiFi()
                print("reachability Reachable via WiFi")
            } else {
                self.delegate?.internetViaCell()
                print("reachability Reachable via Cellular")
            }
            self.delegate?.online()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
