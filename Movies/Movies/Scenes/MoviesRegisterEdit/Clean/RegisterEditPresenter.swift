//
//  RegisterEditPresenter.swift
//  Movies
//
//  Created by Rodrigo Morbach on 09/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

protocol RegisterEditPresentationLogic {
    func presentCategories(response: LoadCategories.Response)
    func presentSavedMovie(response: SaveMovie.Response)
    func presentChangedRating(_ response: ChangeRating.Response)
}

class RegisterEditPresenter {
    weak var viewController: RegisterEditDisplayLogic?    
}

extension RegisterEditPresenter: RegisterEditPresentationLogic {
    func presentCategories(response: LoadCategories.Response) {
        let viewModel = LoadCategories.ViewModel(categories: response.loadedCategories)
        viewController?.displayCategories(viewModel: viewModel)
    }
    
    func presentSavedMovie(response: SaveMovie.Response) {
        let viewModel = SaveMovie.ViewModel()
        viewController?.displaySavedMovie(viewModel: viewModel)
    }
    func presentChangedRating(_ response: ChangeRating.Response) {
        let formattedValue =  String(format: "%\(0.2)f", response.value)
        let viewModel = ChangeRating.ViewModel(formattedValue: formattedValue)
        
        viewController?.displayChangedRating(viewModel: viewModel)
    }
}
