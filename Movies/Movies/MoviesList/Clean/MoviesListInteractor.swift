//
//  MoviesListInteractor.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

protocol MoviesListBusinessLogic {
    func fetchMovies(request: Fetch.Request?)
    func deleteMovie(request: Delete.Request)
    func showMovieDetails(request: ShowDetails.Request)
}

protocol MoviesListDataStore {
    var movie: Movie? { get set }
}

class MoviesListInteractor: MoviesListDataStore {
    var movie: Movie?
    var moviesWorker: MoviesCoreDataProvider?
    var presenter: MoviesListPresentationLogic?
}

extension MoviesListInteractor: MoviesCoreDataProviderDelegate {
    
    func dataDidChange() {
        self.fetchMovies(request: nil)
    }
    
}

extension MoviesListInteractor: MoviesListBusinessLogic {
    
   func fetchMovies(request: Fetch.Request?) {
        moviesWorker?.fetch { [weak self] error, loadedMovies in
            let response = Fetch.Response(movies: loadedMovies)
            self?.presenter?.present(response: response)
        }
    }
    
    func deleteMovie(request: Delete.Request) {
        let result = moviesWorker?.delete(object: request.movie)
        let deleteResponse = Delete.Response(deleted: result ?? false)
        self.presenter?.presentDeleted(response: deleteResponse)
    }
    
    func showMovieDetails(request: ShowDetails.Request) {
        movie = request.movie
    }
    
}
