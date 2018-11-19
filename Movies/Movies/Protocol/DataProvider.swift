//
//  DataProvider.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

protocol DataProvider {
    
    associatedtype T: Any
    
    typealias resultClosure = (_ error: Error?, _ result: [T]?)-> Void
    
    func fetch(completion: resultClosure )->Void
    
    func save(object: T)->Bool
    
    func delete(object: T)->Bool
    
}
