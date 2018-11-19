//
//  AppDelegate.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ app: UIApplication, didFinishLaunchingWithOptions ops: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.applySettings()
        self.preloadMovies()
        return true
    }
    
    private func preloadMovies() {
        
        var insertedCategories = [Category]()
        
        if UserDefaults.standard.bool(forKey: "moviesLoaded") {
            return
        }
    
        let moviesDataProvider = MoviesFileDataProvider()
        let context = CoreDataManager.shared.persistentContainer.viewContext
        moviesDataProvider.fetch {[weak self] error, movies in
            guard let mvs = movies else { return }
            for movie in mvs {
                guard let categories = movie.categories else { continue }
                
                var movieCategories = Set<Category>()
                
                for category in categories {
                    
                    let alreadyInserted = insertedCategories.contains { element in
                        return element.name == category
                    }
                    
                    if alreadyInserted {
                    
                        let insertedCategory = insertedCategories.filter { $0.name == category }
                        if insertedCategory.count > 0 {
                            movieCategories.insert(insertedCategory.first!)
                        }
                        
                    } else {
                        guard let insertedCategory = self?.insertCategory(with: category) else { continue }
                        movieCategories.insert(insertedCategory)
                        insertedCategories.append(insertedCategory)
                    }
                }
                
                let mov = Movie(context: context)
                mov.title = movie.title
                mov.rating = movie.rating ?? 0.0
                mov.duration = movie.duration
                
                if let imgString = movie.image {
                    if let uiImage = UIImage(named: imgString) {
                        mov.imageData = uiImage.jpegData(compressionQuality: 1.0)
                    }
                }
                mov.summary = movie.summary ?? ""
                mov.categories = movieCategories as NSSet
                do {
                    try context.save()
                } catch {
                    debugPrint(error)
                }
            }
        }
        
        UserDefaults.standard.set(true, forKey: "moviesLoaded")
        
    }
    
    private func insertCategory(with name: String) -> Category? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let category = Category(context: context)
        category.name = name
        do {
            try context.save()
            return category
        } catch {
            debugPrint("Failed inserting \(name)")
            return nil
        }
    }
    
    func applySettings() {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            tabBarController.tabBar.barTintColor = UIViewController.themeColor
            if tabBarController.viewControllers != nil {
                for viewController in tabBarController.viewControllers! {
                    if let nvc = viewController as? UINavigationController {
                        nvc.navigationBar.barTintColor = UIViewController.themeColor
                        //nvc.topViewController?.applyLayoutSettings()
                    }
                }
            }
        }
        window?.backgroundColor = UIViewController.themeColor
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.applySettings()
    }
    
}
