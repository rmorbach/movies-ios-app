//
//  MovieDetailInteractor.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

protocol MovieDetailDataStore {
    var movie: Movie? { get set }
}

protocol MovieDetailBusinessLogic {
    func showMovie(request: Display.Request)
}

class MovieDetailInteractor: MovieDetailBusinessLogic, MovieDetailDataStore {
    var presenter: MovieDetailPresentationLogic?
    var movie: Movie?
    
    func showMovie(request: Display.Request) {
        
        guard let movie = movie else { return }
        let response = Display.Response(movie: movie)
        presenter?.presentMovie(response: response)
    }
    
}
