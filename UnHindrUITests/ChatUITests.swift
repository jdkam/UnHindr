//
//  ChatUITests.swift
//  UnHindrUITests
//
//  Created by Jordan Kam on 2019-12-01.
//  Copyright © 2019 Sigma. All rights reserved.
//

import XCTest

class ChatUITests: XCTestCase {

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

    
    func testNavtoChat() {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        
        app.buttons["Chat"].tap()
        XCTAssert(app.buttons["Send Button"].waitForExistence(timeout: 5))
    }
    
    func testWriteMessage() {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        
        app.buttons["Chat"].tap()
        XCTAssert(app.buttons["Send Button"].waitForExistence(timeout: 5))
        
        
        app.textFields["Write a message..."].tap()
        app.textFields["Write a message..."].typeText("Hello world")
        app.buttons["Send Button"].tap()
        app.alerts["Error"].buttons["Ok"].tap()
        
    }
    
    func testWritetoUser() {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        
        
        app.buttons["Connect"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["unittestacc1@gmail.com"].tap()/*[[".cells.staticTexts[\"unittestacc1@gmail.com\"]",".tap()",".press(forDuration: 0.7);",".staticTexts[\"unittestacc1@gmail.com\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,1]]@END_MENU_TOKEN@*/
        app.alerts["Successfully Connected to User!"].buttons["Ok"].tap()
        app.buttons["home white"].tap()
        XCTAssert(app.buttons["Chat"].waitForExistence(timeout: 5))
        app.buttons["Chat"].tap()
        app.textFields["Message Text Field"].tap()
        app.textFields["Message Text Field"].typeText("Hello world")
        app.buttons["Send Button"].tap()
        
        
        
//        app.tables/*@START_MENU_TOKEN@*/.staticTexts["unittestacc1@gmail.com"]/*[[".cells.staticTexts[\"unittestacc1@gmail.com\"]",".staticTexts[\"unittestacc1@gmail.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.alerts["Successfully Connected to User!"].buttons["Ok"].tap()
//        app.buttons["home white"].tap()
//
//        XCTAssert(app.buttons["Chat"].waitForExistence(timeout: 5))
//        app.buttons["Chat"].tap()
//        app.textFields["Write a message..."].typeText("Hello world")
//        app.buttons["Send Button"].tap()
        
        
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

}


