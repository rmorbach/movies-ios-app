//
//  DataCell.swift
//  Movies
//
//  Created by Rodrigo Morbach on 19/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

protocol DataCell {
    
    associatedtype Element: AnyObject
    
    func prepareCell(with object: Element)
}
