//
//  ViewController.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case noInternetConnection
    case serverNotFound
    case osCausedConnectionAbort
    case custom(String)
    case unAvailable
    case other
    case bamboraErr(String)
    case meeErr(String)
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .serverNotFound:
            return "Server Not Found"
        case .osCausedConnectionAbort:
            return "Software caused connection abort"
        case .other:
            return "Something went wrong"
        case .unAvailable:
            return "Server NOT Available"
        case .custom(let message):
            return message
        case .bamboraErr(let msg):
            return msg
        case .meeErr(let msg):
            return msg
        }
        
    }
}

extension ServiceError {
    init(json: JSON) {

        if let data = json["data"] as? [String: Any] {

            guard let output = data["output"] as? [String: Any] else {
                
                if let message =  json["message"] as? String {
                    self = .custom(message)
                } else {
                    self = .other
                }
                
                return
            }
            
            guard let statusCode = output["statusCode"] as? Int else {
                self = .other
                return
            }
            
            self = .custom("HeimdalError" + String(statusCode))
            
        } else if let message =  json["message"] as? String {
            self = .custom(message)
        } else {
            self = .other
        }
    }
}

extension ServiceError {
    init(error: Error) {
        if error.code == -1009 {
            self = .noInternetConnection
        } else if error.code == 53 {
            self = .osCausedConnectionAbort
        } else {
            self = .other
        }
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
