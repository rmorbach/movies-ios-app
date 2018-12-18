//
//  MoviesListRouter.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation
import UIKit

protocol MoviesListRoutingLogic {
    func routeToMovieDetails(with segue: UIStoryboardSegue?)
}

class MoviesListRouter: MoviesListRoutingLogic {
    
    var dataStore: MoviesListDataStore?
    
    weak var viewController: MoviesListDisplayLogic?

    // MARK: - Private methods
    private func passDataToMovieDetails(source: MoviesListDataStore, destination: inout MovieDetailDataStore) {
        destination.movie = dataStore?.movie
    }
    
    // MARK: - MoviesListRoutingLogic methods
    func routeToMovieDetails(with segue: UIStoryboardSegue?) {
        guard let destinationVC = segue?.destination as? MovieDetailViewController else { return }
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToMovieDetails(source: dataStore!, destination: &destinationDS)
        
    }
        
}
