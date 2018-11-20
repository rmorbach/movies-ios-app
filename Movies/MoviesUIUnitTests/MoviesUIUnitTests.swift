//
//  MoviesUIUnitTests.swift
//  MoviesUIUnitTests
//
//  Created by Rodrigo Morbach on 20/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import XCTest

class MoviesUIUnitTests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRatingLabelAfterEditingShouldPass() {
        
        // Tap on "A Forma da água"
        XCUIApplication().tables.staticTexts["A Forma da Água"].tap()
        // Go to edit movie
        app.navigationBars["Movies.MovieDetailView"].buttons["Compose"].tap()
        
        // Change rating to
        let elementsQuery = app.scrollViews.otherElements
        //elementsQuery.sliders["90%"].swipeRight()
        elementsQuery.sliders.firstMatch.adjust(toNormalizedSliderPosition: 0.9)
        app.navigationBars["Edit movie"].buttons["Save"].tap()
        
        // Check if rating label matches
        let ratingElement = elementsQuery.staticTexts["⭐️ 9.00"]        
        XCTAssertNotNil(ratingElement)
    }
    
}
