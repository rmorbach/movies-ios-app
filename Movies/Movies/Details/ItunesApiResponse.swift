//
//  ItunesApiResponse.swift
//  Movies
//
//  Created by Rodrigo Morbach on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

struct ItunesMovie: Codable {
    let previewUrl: String
}

struct ItunesApiResponse: Codable {

    let resultCount: Int
    
    let results: [ItunesMovie]
        
}
