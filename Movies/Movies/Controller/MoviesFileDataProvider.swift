//
//  MoviesFileDataProvider.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class MoviesFileDataProvider: DataProvider {
    
    let assetName = "movies"
        
    func fetch(completion: (Error?, [Movie]?) -> Void) {
        guard let movieSet = NSDataAsset(name: assetName)?.data else {
            //TODO - 
            return
        }
        do {
            let jsonDecoder = JSONDecoder()
            let movies = try jsonDecoder.decode([Movie].self, from: movieSet)
            completion(nil, movies);
        } catch {
            completion(error, nil)
        }
    }
        
    func save(object: Movie) -> Bool {
        return false
    }
    
    func delete(object: Movie) -> Bool {
        return false
    }
}
