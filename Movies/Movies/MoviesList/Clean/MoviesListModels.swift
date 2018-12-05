//
//  MoviesListModel.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

struct Fetch {
    
    struct Request { }
    
    struct Response {
        let movies: [Movie]?
    }
    
    struct ViewModel {
        let movies: [Movie]?
    }
}

struct Delete {
    struct Request {
        let movie: Movie
    }
    
    struct Response {
        let deleted: Bool
    }
    
    struct ViewModel {
        let deleted: Bool
    }
}

struct ShowDetails {
    struct Request {
        let movie: Movie
    }
    
    struct Response {
        
    }
    
    struct ViewModel {
        
    }
    
}
