//
//  MoviesUIUnitTests.swift
//  MoviesUIUnitTests
//
//  Created by Rodrigo Morbach on 20/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//
import XCTest
import FBSnapshotTestCase
@testable import Movies

class MoviesSnapshotUnitTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        //recordMode = true
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMoviesListScreenWithSnapshot() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        XCTAssertNotNil(storyboard)
        
        
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: MoviesTableViewController.self)) as? MoviesTableViewController
        
        XCTAssertNotNil(vc)
        _ = vc?.view
        
        FBSnapshotVerifyView(vc!.view)

    }
    
}
