//
//  String+Extension.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

extension String {
    var ns: NSString {
        return self as NSString
    }
    var pathExtension: String? {
        return ns.pathExtension
    }
    var lastPathComponent: String? {
        return ns.lastPathComponent
    }
}

// MARK: Localized
extension String {
    var localized: String {
        return localizedWithComment(comment: "")
    }
    
    func localizedWithComment(comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
}

extension String {
    func appendZeroesPrefix() -> String {
        var barCodeLocal = self
        while barCodeLocal.count < 6 {
            barCodeLocal.insert("0", at: barCodeLocal.startIndex)
        }
        return barCodeLocal
    }
}

extension String {
    static func requestTraceRandomString(length: Int) -> String {
        let letters = "23456789ABCDEFGHJKLMNOPQRSTUVWXYZ123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    static func clientTraceRandomString(length: Int) -> String {
        let letters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    static func clientTraceID()-> String {
        return "CT-" + clientTraceRandomString(length: 5)
    }
    
    static func requestTraceID()-> String {
        return "RT-" + requestTraceRandomString(length: 5)
    }
}
