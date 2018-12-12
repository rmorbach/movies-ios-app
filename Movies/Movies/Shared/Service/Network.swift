//
//  Network.swift
//  Movies
//
//  Created by Rodrigo Morbach on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

class Network {
    
    typealias HttpCompletionBlock = (Data?, URLResponse?, Error?) -> Void
    
    private class func httpCall(request: NSMutableURLRequest, completion: @escaping HttpCompletionBlock) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        
        let putTask = session.dataTask(with: request as URLRequest) {data, response, err in
            completion(data, response, err)
        }
        putTask.resume()
    }
    
    fileprivate class func get(url: URL, accept: String, completionHandler: @escaping RestCompletionBlock) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        httpCall(request: request) { data, response, error in
            completionHandler(data, response as? HTTPURLResponse, error)
        }
    }
    
    fileprivate class func put(url: URL, contentType: String?, accept: String, payload: Data?, completionHandler: @escaping RestCompletionBlock) {
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "PUT"
        if contentType != nil {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        request.setValue(accept, forHTTPHeaderField: "Accept")
        if payload != nil {
            request.httpBody = payload
        }
        
        httpCall(request: request) { data, response, error in
            completionHandler(data, response as? HTTPURLResponse, error)
        }
        
    }
    
    fileprivate class func post(url: URL, contentType: String?, accept: String, payload: Data?, completionHandler: @escaping RestCompletionBlock) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(accept, forHTTPHeaderField: "Accept")
        request.httpBody = payload
        httpCall(request: request) { data, response, error in
            completionHandler(data, response as? HTTPURLResponse, error)
        }
        
    }
}

extension Network: ServiceAPI {
    func request(to url: URL, method: HTTPMethod, contentType: String?, accept: String, payload: Data?, completionHandler: @escaping RestCompletionBlock) {
        switch method {
        case .get:
            Network.get(url: url, accept: accept, completionHandler: completionHandler)
        case .post:
            Network.post(url: url, contentType: contentType, accept: accept, payload: payload, completionHandler: completionHandler)
        case .put:
            Network.put(url: url, contentType: contentType, accept: accept, payload: payload, completionHandler: completionHandler)
        default: break
            
        }
    }
}
