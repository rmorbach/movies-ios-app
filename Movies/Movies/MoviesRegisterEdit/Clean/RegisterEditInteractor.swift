//
//  RegisterEditInteractor.swift
//  Movies
//
//  Created by Rodrigo Morbach on 09/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

protocol RegisterEditBusinessLogic {
    func cancelSelectingCategory(request: CancelSelectingCategories.Request)
    func loadCategories(request: LoadCategories.Request?)
}

class RegisterEditInteractor: NSObject {
    var worker: CategoriesCoreDataProvider?
    var presenter: RegisterEditPresentationLogic?
}

extension RegisterEditInteractor: RegisterEditBusinessLogic {
    
    // MARK: - Private methods
    private func loadCategories() {
        worker?.fetch(completion: { [weak self] error, loadedCategories in
            
            let response = LoadCategories.Response(loadedCategories: loadedCategories)
            self?.presenter?.presentCategories(response: response)
        })
    }
    
    func cancelSelectingCategory(request: CancelSelectingCategories.Request) {
        
    }
    func loadCategories(request: LoadCategories.Request?) {
        loadCategories()
    }
}

extension RegisterEditInteractor: CategoriesCoreDataProviderDelegate {
    func dataDidChange() {
        self.loadCategories(request: nil)
    }
}
