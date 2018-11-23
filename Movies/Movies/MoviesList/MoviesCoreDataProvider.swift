//
//  MoviesCoreDataProvider.swift
//  Movies
//
//  Created by Rodrigo Morbach on 19/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation
import CoreData

protocol MoviesCoreDataProviderDelegate: NSObjectProtocol {
    func dataDidChange()
}

class MoviesCoreDataProvider: NSObject {

    typealias ModelT = Movie
    
    let coreDataManager = CoreDataManager.shared
    
    weak var delegate: MoviesCoreDataProviderDelegate?
    
    var fetchedResultController: NSFetchedResultsController<Movie>?
    
    // MARK: - Public methods
    init(with delegate: MoviesCoreDataProviderDelegate) {
        self.delegate = delegate
    }

}

extension MoviesCoreDataProvider: DataProvider {
    
    func save(object: ModelT) -> Bool {
        return false
    }
    
    func delete(object: ModelT) -> Bool {
        coreDataManager.context.delete(object)
        do {
            try coreDataManager.context.save()            
        } catch { }
        return true
    }
    
    func fetch(completion: (Error?, [ModelT]?) -> Void) {
        guard let fetchedObjects = fetchedResultController?.fetchedObjects else {

            let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
            let sortTitleDescriptor = NSSortDescriptor(keyPath: \Movie.title, ascending: true)
            
            fetchRequest.sortDescriptors = [sortTitleDescriptor]
            
            let ctx = coreDataManager.context
            
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ctx, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchedResultController = frc
            fetchedResultController?.delegate = self
            do {
                try fetchedResultController?.performFetch()
                completion(nil, fetchedResultController?.fetchedObjects)
            } catch {
                completion(error, nil)
            }

            return
        }
        
        completion(nil, fetchedObjects)
        
    }
    
}

extension MoviesCoreDataProvider: NSFetchedResultsControllerDelegate {
    
    typealias FTRC = NSFetchedResultsController<NSFetchRequestResult>
    func controller(_ controller: FTRC, didChange obj: Any, at idx: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath nIdx: IndexPath?) {
        self.delegate?.dataDidChange()
    }
}
