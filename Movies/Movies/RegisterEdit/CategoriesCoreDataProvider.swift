//
//  CategoriesDataProvider.swift
//  Movies
//
//  Created by Rodrigo Morbach on 19/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation
import CoreData

protocol CategoriesCoreDataProviderDelegate: NSObjectProtocol {
    func dataDidChange()
}

class CategoriesCoreDataProvider: NSObject {
    
    typealias T = Category

    let coreDataManager = CoreDataManager.shared
    
    weak var delegate: CategoriesCoreDataProviderDelegate?
    
    var fetchedResultController: NSFetchedResultsController<Category>?
    
    init(delegate: CategoriesCoreDataProviderDelegate) {
        self.delegate = delegate
    }
    
}

extension CategoriesCoreDataProvider: DataProvider {
    
    func save(object: T) -> Bool {
        return false
    }
    
    func delete(object: T) -> Bool {
        coreDataManager.context.delete(object)
        return true
    }
    
    func fetch(completion: (Error?, [T]?) -> Void) {
        guard let fetchedObjects = fetchedResultController?.fetchedObjects else {
            
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            let sortTitleDescriptor = NSSortDescriptor(keyPath: \Category.name, ascending: true)
            
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


extension CategoriesCoreDataProvider: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.delegate?.dataDidChange()
    }
}
