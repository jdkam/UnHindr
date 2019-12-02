//
//  GraphsUITests.swift
//  UnHindrUITests
//
//  Created by Johnston Yang on 2019-12-01.
//  Copyright © 2019 Sigma. All rights reserved.
//

import XCTest

class GraphsUITests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNavigationtoCogWeekGraph() {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        app.buttons["Wellness"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Graph"].tap()
        elementsQuery.buttons["CogGame graph button"].tap()
    }
    
    
    func testNavigationtoMoodWeekGraph()
    {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        app.buttons["Wellness"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Graph"].tap()
        elementsQuery.buttons["Mood Graph Button"].tap()
    }
    
    func testNavigationtoMotorMonthGraph()
    {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        app.buttons["Wellness"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Graph"].tap()
        elementsQuery.buttons["Motorgame graph button"].tap()
        app.buttons["Month 1"].tap()
    }
    
    func testNavigationtoMotorYearGraph()
    {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        app.buttons["Wellness"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Graph"].tap()
        elementsQuery.buttons["Motorgame graph button"].tap()
        app.buttons["Year 1"].tap()
    }
    
    
    // MARK: - Helper Functions
    // Input:
    //      1. Current application instance
    // Output:
    //      1. Home screen with wait (Warning: dependent on profile button)
    func loginToHomeScreen(_ app: XCUIApplication){
        // Login to the home screen
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("unittestacc@gmail.com\n")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("testtest\n")
        app.buttons["Login Button"].tap()
    }
    
    // Input:
    //      1. Current application instance
    // Output:
    //      1. Home screen with wait (Warning: dependent on profile button)
    //Login in caregiver usermode
    func loginAsCaregiver(_ app: XCUIApplication){
        // Login to the home screen
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("unittestacc1@gmail.com\n")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("testtest1\n")
        app.buttons["Login Button"].tap()
        //Wait
        XCTAssert(app.buttons["OptionsButton"].waitForExistence(timeout: 5))
    }
}
