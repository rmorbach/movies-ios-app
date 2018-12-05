//
//  TrailerServiceUnitTests.swift
//  MoviesUnitTests
//
//  Created by Rodrigo Morbach on 19/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import XCTest

@testable import Movies

class TrailerServiceUnitTests: XCTestCase {

    let service = TrailerService()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testServiceShouldPass() {
        let expectation = XCTestExpectation(description: "Trailer service expectation")
        let movieName = "Deadpool 2"
        
        service.trailerUrlFor(movie: movieName) { url, serviceError in
            XCTAssertNil(serviceError)
            XCTAssertNotNil(url)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        
    }
    
    func testServiceInvalidNameShouldFail() {
        let expectation = XCTestExpectation(description: "Trailer service expectation")
        let movieName = "Some random movie"
        
        service.trailerUrlFor(movie: movieName) { url, serviceError in
            XCTAssertNil(url)
            XCTAssertNotNil(serviceError)
            XCTAssertEqual(serviceError, ServiceError.emptyResponse)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    
    /// In order to make this test pass it is necessary to change apiBaseURL in TraillerService.swift file.
    func testServiceInvalidUrlShouldFail() {
        let expectation = XCTestExpectation(description: "Invalid URL expectation")
        let movieName = "Some random movie"
        
        service.trailerUrlFor(movie: movieName) { url, serviceError in
            XCTAssertNil(url)
            XCTAssertNotNil(serviceError)
            XCTAssertEqual(serviceError, ServiceError.invalidUrl)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
}
