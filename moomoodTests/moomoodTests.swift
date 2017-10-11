//
//  moomoodTests.swift
//  moomoodTests
//
//  Created by Jennifer Bacon on 11/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import XCTest
@testable import moomood

class moomoodTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMoodCanBeInstantiatedWithDateAndRating() {
        var mood = Mood(date:"11/10/17",rating:5)
        XCTAssertEqual(mood.date, "11/10/17")
        XCTAssertEqual(mood.rating, 5)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
