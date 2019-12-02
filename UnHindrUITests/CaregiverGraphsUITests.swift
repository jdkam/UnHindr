//
//  CaregiverGraphsUITests.swift
//  UnHindrUITests
//
//  Created by Johnston Yang on 2019-12-01.
//  Copyright © 2019 Sigma. All rights reserved.
//

import XCTest

class CaregiverGraphsUITests: XCTestCase {

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

    func testNoSelectedPatientMed()
    {
        let app = XCUIApplication()
        loginAsCaregiver(app)
        app.buttons["Medication"].tap()
        app.alerts["No Patient Selected"].buttons["Ok"].tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testNoSelectedPatientCog()
    {
        let app = XCUIApplication()
        loginAsCaregiver(app)
        app.buttons["Wellness"].tap()
        app.scrollViews.otherElements.buttons["CogGame graph button"].tap()
    }
    
    func testNoSelectedPatientMood()
    {
        let app = XCUIApplication()
        loginAsCaregiver(app)
        app.buttons["Wellness"].tap()
        app.scrollViews.otherElements.buttons["Mood Graph Button"].tap()
    }
    
    func testNoSelectedPatientMotor()
    {
        let app = XCUIApplication()
        loginAsCaregiver(app)
        app.buttons["Wellness"].tap()
        app.scrollViews.otherElements.buttons["Motorgame graph button"].tap()
    }
    
    func testNavigationToMedWeek()
    {
        let app = XCUIApplication()
        loginAsCaregiver(app)
        app.buttons["Connect"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["unittestacc@gmail.com"]/*[[".cells.staticTexts[\"unittestacc@gmail.com\"]",".staticTexts[\"unittestacc@gmail.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Successfully Connected to User!"].buttons["Ok"].tap()
        app.buttons["home white"].tap()
        app.buttons["Medication"].tap()
    }
    
    func testNavigationToMedMonth()
    {
        let app = XCUIApplication()
        loginAsCaregiver(app)
        app.buttons["Connect"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["unittestacc@gmail.com"]/*[[".cells.staticTexts[\"unittestacc@gmail.com\"]",".staticTexts[\"unittestacc@gmail.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Successfully Connected to User!"].buttons["Ok"].tap()
        app.buttons["home white"].tap()
        app.buttons["Medication"].tap()
        app.buttons["Month"].tap()
    }
    
    func testNavigationToMedYear()
    {
        let app = XCUIApplication()
        loginAsCaregiver(app)
        app.buttons["Connect"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["unittestacc@gmail.com"]/*[[".cells.staticTexts[\"unittestacc@gmail.com\"]",".staticTexts[\"unittestacc@gmail.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Successfully Connected to User!"].buttons["Ok"].tap()
        app.buttons["home white"].tap()
        app.buttons["Medication"].tap()
        app.buttons["Year"].tap()
    }
    
    func testNavigationToCogWeek()
    {
        let app = XCUIApplication()
        loginAsCaregiver(app)
        app.buttons["Connect"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["unittestacc@gmail.com"]/*[[".cells.staticTexts[\"unittestacc@gmail.com\"]",".staticTexts[\"unittestacc@gmail.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Successfully Connected to User!"].buttons["Ok"].tap()
        app.buttons["home white"].tap()
        
    }
    
    func testNavigationToCogMonth()
    {
        
    }
    
    func testNavigationToCogYear()
    {
        
    }
    
    func testNavigationToMoodWeek()
    {
        
    }
    
    func testNavigationToMoodMonth()
    {
        
    }
    
    func testNavigationToMoodYear()
    {
        
    }
    
    func testNavigationToMotorWeek()
    {
        
    }
    
    func testNavigationToMotorMonth()
    {
        
    }
    
    func testNavigationToMotorYear()
    {
        
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
