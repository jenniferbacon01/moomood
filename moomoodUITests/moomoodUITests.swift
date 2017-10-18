//
//  moomoodUITests.swift
//  moomoodUITests
//
//  Created by Jennifer Bacon on 11/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import XCTest

class moomoodUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTopTextLabelIsDisplayed() {
        app.tabBars.buttons["Sense"].tap()
        XCTAssert(app.staticTexts["How do you feel?"].exists)
    }
    
    func testButtonsArePresent() {
        app.tabBars.buttons["Sense"].tap()
        XCTAssert(app.buttons["1"].exists)
        XCTAssert(app.buttons["2"].exists)
        XCTAssert(app.buttons["3"].exists)
        XCTAssert(app.buttons["4"].exists)
        XCTAssert(app.buttons["5"].exists)
    }
    
    func testButton1DisplaysLabel() {
        app.tabBars.buttons["Sense"].tap()
        app.buttons["1"].tap()
        XCTAssert(app.staticTexts["you chose 1"].exists)
    }
    
    func testButton2DisplaysLabel() {
        app.tabBars.buttons["Sense"].tap()
        app.buttons["2"].tap()
        XCTAssert(app.staticTexts["you chose 2"].exists)
    }
    
    func testButton3DisplaysLabel() {
        app.tabBars.buttons["Sense"].tap()
        app.buttons["3"].tap()
        XCTAssert(app.staticTexts["you chose 3"].exists)
    }
    
    func testButton4DisplaysLabel() {
        app.tabBars.buttons["Sense"].tap()
        app.buttons["4"].tap()
        XCTAssert(app.staticTexts["you chose 4"].exists)
    }
    
    func testButton5DisplaysLabel() {
        app.tabBars.buttons["Sense"].tap()
        app.buttons["5"].tap()
        XCTAssert(app.staticTexts["you chose 5"].exists)
    }
    
    func testWhyMessageIsDisplayed() {
        app.tabBars.buttons["Sense"].tap()
        app.buttons["5"].tap()
        XCTAssert(app.staticTexts["Why do you feel like this?"].exists)
    }
    
    func testCauseButtonsAreDisplayed() {
        app.tabBars.buttons["Sense"].tap()
        app.buttons["5"].tap()
        XCTAssert(app.buttons["Work"].exists)
        XCTAssert(app.buttons["Family"].exists)
        XCTAssert(app.buttons["Partner"].exists)
        XCTAssert(app.buttons["Health"].exists)
        XCTAssert(app.buttons["Home"].exists)
        XCTAssert(app.buttons["Finances"].exists)
        XCTAssert(app.buttons["Weather"].exists)
        XCTAssert(app.buttons["Other"].exists)
        XCTAssert(app.buttons["I'd rather not say"].exists)
    }
    
    func testJournalViewIsDisplayed() {
        app.tabBars.buttons["Journal"].tap()
        XCTAssert(app.staticTexts["Your moods over the last 10 days"].exists)
        XCTAssert(app.staticTexts["Average Mood"].exists)
        XCTAssert(app.staticTexts["You have recorded the following moods...."].exists)
    }
    
    func testHistoryViewIsDisplayed() {
        app.tabBars.buttons["Journal"].tap()
        app.navigationBars["moomood.AnalysisView"].buttons["History"].tap()
        XCTAssert(app.staticTexts["History"].exists)
        XCTAssert(app.staticTexts["Date                   Rating            Reason"].exists)
    }
    
    func testBackButtonHistoryViewWorks() {
        app.tabBars.buttons["Journal"].tap()
        app.navigationBars["moomood.AnalysisView"].buttons["History"].tap()
        app.buttons["Back"].tap()
        XCTAssert(app.staticTexts["Your moods over the last 10 days"].exists)
        XCTAssert(app.staticTexts["Average Mood"].exists)
        XCTAssert(app.staticTexts["You have recorded the following moods...."].exists)
    }
    
    
    func testChartsViewIsDisplayed() {
        app.tabBars.buttons["Charts"].tap()
        XCTAssert(app.staticTexts["Charts"].exists)
    }
    
    func testChatbotViewIsDisplayed() {
        app.tabBars.buttons["MoomooBot"].tap()
        XCTAssert(app.navigationBars["Moomoo"].exists)
    }
    
    func testBackButtonChatbotViewWorks() {
        app.tabBars.buttons["MoomooBot"].tap()
        let moomooNavigationBar = app.navigationBars["Moomoo"]
        moomooNavigationBar.buttons["Back"].tap()
        XCTAssert(app.staticTexts["How do you feel?"].exists)
    }
    
}
