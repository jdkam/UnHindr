/*
 File: [EmergContactUITests]
 Creators: [Jake]
 Date created: [30/11/2019]
 Date updated: [30/11/2019]
 Updater name: [Jake]
 File description: [Runs the UI tests for the Emergency Contact feature]
 */

import XCTest
@testable import UnHindr

class EmergencyContactUITests: XCTestCase {
    
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
    // MARK: - Test navigation to Emergency Contact from login
    // Input:
    //      1. None
    // Output:
    //      1. Emergency Contact screen with countdown timer present
    func testNavigationToEmergencyContact() {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        
        app.buttons["Emergency"].tap()
        XCTAssert(app.buttons["Timer"].waitForExistence(timeout: 5))
    }
    
    // MARK: - Test waiting for the Emergency Notification to be sent
    // Input:
    //      1. None
    // Output:
    //      1. After waiting 20 seconds, alert pops up and screen is transitioned to Home Screen
    func testEmergencyNotificationSend() {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        
        app.buttons["Emergency"].tap()
        sleep(20)
        XCTAssert(app.staticTexts["The Emergency Notification has been sent."].waitForExistence(timeout: 5))
        XCTAssert(app.buttons["Emergency"].waitForExistence(timeout: 5))
    }
    
    // MARK: - Test holding the screen to cancel the notification
    // Input:
    //      1. None
    // Output:
    //      1. After pressing the screen for a sufficient amount of time, the notification is cancelled
    func testCancelEmergencyNotification() {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        
        app.buttons["Emergency"].tap()
        app.press(forDuration: 3.5)
        XCTAssertFalse(app.staticTexts["The Emergency Notification has been sent."].waitForExistence(timeout: 5))
        XCTAssert(app.buttons["Emergency"].waitForExistence(timeout: 5))
    }
    
    // MARK: - Helper Functions
    // Input:
    //      1. Current application instance
    // Output:
    //      1. Home screen with wait
    func loginToHomeScreen(_ app: XCUIApplication){
        // Login to the home screen
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("unittestacc@gmail.com\n")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("testtest\n")
        app.buttons["Login Button"].tap()
        //Wait
        XCTAssert(app.buttons["Emergency"].waitForExistence(timeout: 5))
        
        
    }
}
