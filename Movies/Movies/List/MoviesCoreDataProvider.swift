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
    func dataDidChange();
}

class MoviesCoreDataProvider: NSObject {
    typealias T = Movie
    
    static let shared = MoviesCoreDataProvider()
    let coreDataManager = CoreDataManager.shared
    
    var delegates = [MoviesCoreDataProviderDelegate]()
    
    var fetchedResultController: NSFetchedResultsController<Movie>?

    // MARK - Private methods
    
    private override init() {
        super.init()
    }
    
    // MARK - Public methods
    func add<D: MoviesCoreDataProviderDelegate> (delegate: D) -> Void where D: Equatable {
        
        let contains = delegates.contains { return $0.isEqual(delegate) }
        
        if contains { return }
        
        delegates.append(delegate)
    }
    
    func remove<D: MoviesCoreDataProviderDelegate> (delegate: D) -> Void where D: Equatable {
        delegates.removeAll { element -> Bool in
            return element.isEqual(delegate)
        }
    }
    
}

extension MoviesCoreDataProvider: DataProvider {
    
    func save(object: T) -> Bool {
        return false
    }
    
    func delete(object: T) -> Bool {
        coreDataManager.context.delete(object)
        return true
    }
    
    func fetch(completion: (Error?, [T]?) -> Void) {
        guard let fetchedObjects = fetchedResultController?.fetchedObjects else {

            let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
            let sortTitleDescriptor = NSSortDescriptor(keyPath: \Movie.title, ascending: true)
            
            fetchRequest.sortDescriptors = [sortTitleDescriptor];
            
            fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchedResultController?.delegate = self;
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        for delegate in delegates {
            delegate.dataDidChange()
        }
        
    }
}

