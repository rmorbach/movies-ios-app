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
    func saveMovie(request: SaveMovie.Request)
    func changeRating(request: ChangeRating.Request)
}

protocol RegisterEditDataStore {
    var movie: Movie? { get set }
}

class RegisterEditInteractor: NSObject, RegisterEditDataStore {
    var worker: CategoriesCoreDataProvider?
    var presenter: RegisterEditPresentationLogic?
    var movie: Movie?
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
    
    func saveMovie(request: SaveMovie.Request) {
        let coreDataManager = CoreDataManager.shared
        if self.movie == nil {
            self.movie = Movie(context: coreDataManager.context)
        }
        
        self.movie?.title = request.title
        self.movie?.imageData = request.imageData ?? self.movie?.imageData
        self.movie?.summary = request.summary
        self.movie?.categories = request.categories as NSSet
        self.movie?.rating = request.rating ?? 0.0
        self.movie?.duration = request.duration
        coreDataManager.save()
        
        let response = SaveMovie.Response()
        presenter?.presentSavedMovie(response: response)
    }
 
    func changeRating(request: ChangeRating.Request) {
        let response = ChangeRating.Response(value: request.value)
        presenter?.presentChangedRating(response)
    }
}

extension RegisterEditInteractor: CategoriesCoreDataProviderDelegate {
    func dataDidChange() {
        self.loadCategories(request: nil)
    }
}
