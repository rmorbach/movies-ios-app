//
//  MovieDetailRouter.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation
import UIKit

protocol MovieDetailRoutingLogic {
    func routeToEditScreen(with segue: UIStoryboardSegue?)
}

protocol MovieDetailDataPassing {
    var dataStore: MovieDetailDataStore? { get }
}

class MovieDetailRouter: MovieDetailRoutingLogic, MovieDetailDataPassing {
    
    var dataStore: MovieDetailDataStore?
    
    private func passDataToEditScreen(source: MovieDetailDataStore, destination: inout RegisterEditDataStore) {
        destination.movie = dataStore?.movie
    }
    
    func routeToEditScreen(with segue: UIStoryboardSegue?) {
        guard let destinationVC = segue?.destination as? RegisterEditMovieViewController else { return }
        
        var destinationDS = destinationVC.router!.dataStore!
        passDataToEditScreen(source: dataStore!, destination: &destinationDS)
        
    }
    
}
