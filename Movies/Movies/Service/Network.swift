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
    typealias RestCompletionBlock = (Data?, HTTPURLResponse?, Error?) -> Void
    
    private class func httpCall(request: NSMutableURLRequest, completion: @escaping HttpCompletionBlock) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        
        let putTask = session.dataTask(with: request as URLRequest) {data, response, err in
            completion(data, response, err)
        }
        putTask.resume()
    }
    
    public class func get(url: URL, accept: String, completionHandler: @escaping RestCompletionBlock) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        httpCall(request: request) { data, response, error in
            completionHandler(data, response as? HTTPURLResponse, error)
        }
    }
    
    public class func put(url: URL, contentType: String?, accept: String, payload: Data?, completionHandler: @escaping RestCompletionBlock) {
        
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
    
    public class func post(url: URL, contentType: String?, accept: String, payload: Data?, completionHandler: @escaping RestCompletionBlock) {
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
