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
    
    typealias ModelT = Category

    let coreDataManager = CoreDataManager.shared
    
    weak var delegate: CategoriesCoreDataProviderDelegate?
    
    var fetchedResultController: NSFetchedResultsController<Category>?
    
    init(delegate: CategoriesCoreDataProviderDelegate) {
        self.delegate = delegate
    }
    
}

extension CategoriesCoreDataProvider: DataProvider {
    
    func save(object: ModelT) -> Bool {
        return false
    }
    
    func delete(object: ModelT) -> Bool {
        coreDataManager.context.delete(object)
        return true
    }
    
    func fetch(completion: (Error?, [ModelT]?) -> Void) {
        guard let fetchedObjects = fetchedResultController?.fetchedObjects else {
            
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            let sortTitleDescriptor = NSSortDescriptor(keyPath: \Category.name, ascending: true)
            
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

extension CategoriesCoreDataProvider: NSFetchedResultsControllerDelegate {
    typealias FTRC = NSFetchedResultsController<NSFetchRequestResult>
    func controller(_ controller: FTRC, didChange obj: Any, at idx: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath nIdx: IndexPath?) {
        self.delegate?.dataDidChange()
    }
}
