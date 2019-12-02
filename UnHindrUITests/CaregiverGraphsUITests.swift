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
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testNoSelectedPatientCog()
    {
        
    }
    
    func testNoSelectedPatientMood()
    {
        
    }
    
    func testNoSelectedPatientMotor()
    {
        
    }
    
    func testNavigationToMedWeek()
    {
        
    }
    
    func testNavigationToMedMonth()
    {
        
    }
    
    func testNavigationToMedYear()
    {
        
    }
    
    func testNavigationToCogWeek()
    {
        
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
