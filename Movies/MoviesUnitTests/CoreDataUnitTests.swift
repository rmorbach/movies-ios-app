//
//  CoreDataUnitTests.swift
//  MoviesUnitTests
//
//  Created by Rodrigo Morbach on 19/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import XCTest
@testable import Movies

class CoreDataUnitTests: XCTestCase {

    typealias MovieCategory = Movies.Category
    
    override func setUp() {
        deleteMoviesFromCoreData()
        insertMoviesInCoreData()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        deleteMoviesFromCoreData()
    }
    
    func testFetchPreloadedMoviesShouldPass() {
        let expectation = XCTestExpectation(description: "Fetch expectation")
        let moviesDataProvider = MoviesCoreDataProvider(with: self)
        moviesDataProvider.fetch { error, moviesLoaded in
            XCTAssertNil(error)
            XCTAssertNotNil(moviesLoaded)
            XCTAssertEqual(moviesLoaded?.count, 8)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    
    private func deleteMoviesFromCoreData() {
    
        let moviesDataProvider = MoviesCoreDataProvider(with: self)
        moviesDataProvider.fetch { error, moviesLoaded in
            for movie in moviesLoaded! {
                let _ = moviesDataProvider.delete(object: movie)
            }
            UserDefaults.standard.set(false, forKey: "moviesLoaded")
        }
    
    }
    
    private func insertMoviesInCoreData() {
        var insertedCategories = [MovieCategory]()
    
        let moviesDataProvider = MoviesFileDataProvider()
        let context = CoreDataManager.shared.persistentContainer.viewContext
        moviesDataProvider.fetch {[weak self] error, movies in
            guard let mvs = movies else { return }
            for movie in mvs {
                guard let categories = movie.categories else { continue }
                
                var movieCategories = Set<MovieCategory>()
                
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
    }
    
    
    private func insertCategory(with name: String) -> MovieCategory? {
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

}


extension CoreDataUnitTests: MoviesCoreDataProviderDelegate {
    func dataDidChange() {
        // Ignore
    }
}
