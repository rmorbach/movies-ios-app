//
//  UIViewController+CoreData.swift
//  Movies
//
//  Created by Rodrigo Morbach on 15/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    var coreDataManager: CoreDataManager {
        return CoreDataManager.shared
    }

    var context: NSManagedObjectContext {
        return coreDataManager.persistentContainer.viewContext
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            debugPrint(error)
        }
    }

}
