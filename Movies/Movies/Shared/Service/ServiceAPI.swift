//
//  File.swift
//  Movies
//
//  Created by Rodrigo Morbach on 12/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

typealias RestCompletionBlock = (Data?, HTTPURLResponse?, Error?) -> Void

protocol ServiceAPI {
    func request(to url: URL, method: HTTPMethod, contentType: String?, accept: String, payload: Data?, completionHandler: @escaping RestCompletionBlock)    
}
