//
//  MovieDetailRouter.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

protocol MovieDetailRoutingLogic {
    
}

protocol MovieDetailDataPassing
{
    var dataStore: MovieDetailDataStore? { get }
}


class MovieDetailRouter: MovieDetailRoutingLogic, MovieDetailDataPassing {
    
    var dataStore: MovieDetailDataStore?
    
}
