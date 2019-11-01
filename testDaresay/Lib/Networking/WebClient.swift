//
//  ViewController.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation
import UIKit

public typealias JSON = [String: Any]
public typealias HTTPHeaders = [String: String]

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

let reachability = Reachability()!

class WebClient {
    
    private var baseUrl: String
    
    public init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func loadData(path: String, method: RequestMethod, params: Data?, headers: HTTPHeaders? = nil, shouldPrintLog: Bool = false, completion: @escaping (Any?, Data?, ServiceError?) -> ()) -> URLSessionUploadTask? {
        
        guard ReachabilityHelper.shared.reachability.connection != .none else {
            completion(nil, nil, ServiceError.noInternetConnection)
            return nil
        }
        
        // 1. Endpoint String
        let apiURLString = baseUrl
        // 2. Body For URL
        var urlComponents = URLComponents(string: apiURLString)!
        urlComponents.path += path
        // 3. URL
        let completeURL = urlComponents.url!
        // 4. URL Req
        var urlReq = URLRequest(url: completeURL)
        urlReq.httpMethod = method.rawValue
        urlReq.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        if headers != nil {
            for (key, value) in headers! {
                urlReq.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let getPublicKeyData = params
        let uploadDTask = URLSession.shared.uploadTask(with: urlReq, from: getPublicKeyData) { (data, urlResponse, error) in
            
            if shouldPrintLog {
                self.logResponse(data: data, httpResponse: urlResponse, error: error)
            }
            
            guard error == nil else {
                completion(nil, nil, nil)
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                completion(urlResponse, data, nil)
                return
            }
            
            if let json = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                aprint("uploadDTask")
                aprint(json ?? "")
            }
            
            if httpResponse.statusCode == 200 {
                completion(urlResponse, data, nil)
            } else {
                completion(urlResponse, nil, nil)
            }
        }
        
        if shouldPrintLog {
            urlReq.log()
        }
        
        uploadDTask.resume()
        
        return uploadDTask
    }
    
    func load(path: String, method: RequestMethod, params: JSON?, headers: HTTPHeaders? = nil, shouldPrintLog: Bool = false, completion: @escaping (Any?, Data?, ServiceError?) -> ()) -> URLSessionDataTask? {
        
        guard ReachabilityHelper.shared.reachability.connection != .none else {
            completion(nil, nil, ServiceError.noInternetConnection)
            return nil
        }
        
        let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: params, headers: headers)
        
        // Sending request to the server.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if shouldPrintLog {
                self.logResponse(data: data, httpResponse: response, error: error)
            }
            
            // Parsing incoming data
            var object: Any? = nil
            
            if let data = data {
                object = try? JSONSerialization.jsonObject(with: data, options: [])
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                completion(object, data, nil)
            } else if let httpResponse = response as? HTTPURLResponse, (400..<500) ~= httpResponse.statusCode {

                if let objectAsJSON = object {
                    completion(object, data, ServiceError(json: objectAsJSON as! JSON))
                } else {
                    completion(object, data, ServiceError.serverNotFound)
                }
                
            } else if let httpResponse = response as? HTTPURLResponse, (500..<600) ~= httpResponse.statusCode {
                guard let object = object else { return }
                let err = ServiceError(json: object as! JSON)
                completion(object, data, err)
            } else {
                
                if let errorLocal = error {
                    let err = ServiceError(error: errorLocal)
                    completion(nil, nil, err)
                    return
                }
                
                let error = (object as? JSON).flatMap(ServiceError.init) ?? ServiceError.other
                completion(nil, nil, error)
            }
        }
        
        if shouldPrintLog {
            request.log()
        }

        task.resume()
        return task
    }
}

extension URLRequest {
    init(baseUrl: String, path: String, method: RequestMethod, params: JSON?, headers: HTTPHeaders? = nil) {
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        httpMethod = method.rawValue
        
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if headers != nil {
            for (key, value) in headers! {
                setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Set header JWS token
        switch method {
        case .post, .put, .patch:
            guard let params = params else { break }
            let dataForBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            //let payloadString = dataForBody.base64EncodedString(options: []); //aprint("payloadString for body: \(payloadString)")
            httpBody = dataForBody
        default:
            break
        }
    }
}

extension URL {
    init(baseUrl: String, path: String, params: JSON?, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        switch method {
        case .get, .delete:
            guard let params = params else { break }
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        self = components.url!
    }
}

extension WebClient {
    func logResponse(data: Data?, httpResponse: URLResponse?, error: Error?) {
        print("⏪⏪⏪⏪⏪⏪⏪")
        print("data: \n\(String(describing: data))\n")
        print("response: \n\(String(describing: httpResponse))\n")
        print("error: \n\(String(describing: error))\n")
        
        guard let data = data else {
            print("⏪⏪⏪⏪⏪⏪⏪")
            return
        }
        
        print(data.prettyPrintedJSONString ?? "")
        print("⏪⏪⏪⏪⏪⏪⏪")
    }
}

extension URLRequest {
    func log() {
        print("⏩⏩⏩⏩⏩⏩⏩")
        print("METHOD: \(httpMethod ?? "")")
        print("URL: \(self)")
        if let body = httpBody {
            print("BODY: \n \(body.toString() ?? "")")
        } else {
            print("BODY: None")
        }
        print("HEADERS: \n \(allHTTPHeaderFields ?? ["":""])")
        print("⏩⏩⏩⏩⏩⏩⏩")
    }
}

extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
