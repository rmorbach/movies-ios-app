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
}

class RegisterEditPresenter {
    weak var viewController: RegisterEditDisplayLogic?
}

extension RegisterEditPresenter: RegisterEditPresentationLogic {
    func presentCategories(response: LoadCategories.Response) {
        let viewModel = LoadCategories.ViewModel(categories: response.loadedCategories)
        viewController?.displayCategories(viewModel: viewModel)
    }
}
