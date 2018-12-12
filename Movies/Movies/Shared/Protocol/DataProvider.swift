//
//  DataProvider.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

protocol DataProvider {
    
    associatedtype ModelT: Any
    
    typealias ResultClosure = (_ error: Error?, _ result: [ModelT]?) -> Void
    
    func fetch(completion: ResultClosure)
    
    func save(object: ModelT) -> Bool
    
    func delete(object: ModelT) -> Bool
    
}
