//
//  MoviesListPresenter.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

protocol MoviesListPresentationLogic {
    func present(response: Fetch.Response)
    func presentDeleted(response: Delete.Response)
}

class MoviesListPresenter: MoviesListPresentationLogic {
    
    weak var viewController: MoviesListDisplayLogic?
    
    func present(response: Fetch.Response) {
        if response.movies != nil {
            let viewModel = Fetch.ViewModel.success(response.movies!)
            viewController?.displayMovies(viewModel: viewModel)
        } else {
            let viewModel = Fetch.ViewModel.error
            viewController?.displayMovies(viewModel: viewModel)
        }
        
    }
    
    func presentDeleted(response: Delete.Response) {
        let viewModel = Delete.ViewModel(deleted: response.deleted)
        viewController?.displayDeleted(viewModel: viewModel)
    }
}
