//
//  Networking.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/18/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation
import os.log

enum HttpMethod: String {
    case get
    case post
    case patch
    case delete
}

class Networking {
    
    private init() { }
    
    static func createParameters(parameters: [String: Any]) -> Data? {
        do {
            if let serializedParameters = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
                return serializedParameters
            } else {
                os_log("Invalid parameters used %{PUBLIC}@", log: .networking, type: .error, parameters)
                return nil
            }
        }
    }
    
    static func sendRequest(httpMethod: HttpMethod = .get, endpoint: String, httpBody: Data? = nil, onCompletion: @escaping (Data) -> (), onError: @escaping (String) -> () ) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: endpoint) else {
                onError("Error: Cannot create URL.")
                return
            }
            
            var urlRequest = URLRequest(url: url)
            let session = URLSession(configuration: URLSessionConfiguration.default)
            urlRequest.httpMethod = httpMethod.rawValue.uppercased()
            urlRequest.addValue("Bearer \(Scratch.bearerToken)", forHTTPHeaderField: "Authorization")
            
            if httpBody != nil {
                urlRequest.httpBody = httpBody
                urlRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
            }
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                guard let responseData = data else {
                    onError("Error: No data returned from \(endpoint).")
                    return
                }
                guard error == nil else {
                    onError("Error: \(String(describing: error))")
                    return
                }
                onCompletion(responseData)
            })
            task.resume()
        }
    }
}
