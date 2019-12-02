/*
 File: [UnHindrUITests.swift]
 Creators: [Allan Tsai]
 Date created: [10/28/2019]
 Date updated: [11/17/2019]
 Updater name: [Jordan, Allan]
 File description: [Tests the UI navigation for the Core UI of the app]
 */

import XCTest
@testable import UnHindr

class UnHindrUITests: XCTestCase {
    func a() { print ("something") }
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
    
    // tests textfields and buttons
    func testLoginPage() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        XCTAssert(app.textFields["Email"].exists)
        XCTAssert(app.secureTextFields["Password"].exists)
        XCTAssert(app.buttons["Login Button"].exists)
    }
    
    //tests all input fields and buttons
    func testNavigationToProfile(){
        let app = XCUIApplication()
        loginToHomeScreen(app)

        XCTAssert(app.buttons["Profile"].waitForExistence(timeout: 5))
        app.buttons["Profile"].tap()
        //Check to see if all element exists
        XCTAssert(app.textFields["First Name"].exists)
        XCTAssert(app.textFields["Last Name"].exists)
        XCTAssert(app.textFields["Email Name"].exists)
        XCTAssert(app.textFields["Date of Birth"].exists)
        XCTAssert(app.textFields["Cell"].exists)
        XCTAssert(app.textFields["Gender"].exists)
        XCTAssert(app.textFields["Address"].exists)
        XCTAssert(app.buttons["Save Button"].exists)
        XCTAssert(app.buttons["Back Button"].exists)
        
        //TODO: test fields  with save button
        
        //Check for back button
        app.buttons["Back Button"].tap()
        //Check if back at home screen
        XCTAssert(app.buttons["Profile"].waitForExistence(timeout: 5))
        
    }
    
    // tests all input fields and buttons
    func testNavigationToWellness(){
        let app = XCUIApplication()
        loginToHomeScreen(app)
        
        // Constants for user selection
        let stronglyAgreeButton = app.buttons["Strongly Agree"]
        let agreeButton = app.buttons["Agree"]
        let neutralButton = app.buttons["Neutral"]
        let disagreeButton = app.buttons["Disagree"]
        let stronglyDisagreeButton = app.buttons["Strongly Disagree"]
        let nextButton = app.buttons["Next"]
        
        //Check if wellness test exists and navigate
        XCTAssert(app.buttons["Wellness"].waitForExistence(timeout: 5))
        app.buttons["Wellness"].tap()
        
        XCTAssert(app.scrollViews.otherElements.buttons["MoodSurveyButton"].waitForExistence(timeout: 5))
        // Wellness page homescreen
//        XCTAssert(app.buttons["Mood Survey Button"].waitForExistence(timeout: 5))
        app.buttons["MoodSurveyButton"].tap()
        
        // Q1
        XCTAssert(stronglyAgreeButton.waitForExistence(timeout: 5))
        XCTAssert(stronglyAgreeButton.exists)
        XCTAssert(agreeButton.exists)
        XCTAssert(neutralButton.exists)
        XCTAssert(disagreeButton.exists)
        XCTAssert(stronglyDisagreeButton.exists)
        stronglyAgreeButton.tap()
        nextButton.tap()
        
        //Q2
        XCTAssert(stronglyAgreeButton.waitForExistence(timeout: 5))
        XCTAssert(stronglyAgreeButton.exists)
        XCTAssert(agreeButton.exists)
        XCTAssert(neutralButton.exists)
        XCTAssert(disagreeButton.exists)
        XCTAssert(stronglyDisagreeButton.exists)
        stronglyDisagreeButton.tap()
        nextButton.tap()
        
        //Q3
        XCTAssert(stronglyAgreeButton.waitForExistence(timeout: 5))
        XCTAssert(stronglyAgreeButton.exists)
        XCTAssert(agreeButton.exists)
        XCTAssert(neutralButton.exists)
        XCTAssert(disagreeButton.exists)
        XCTAssert(stronglyDisagreeButton.exists)
        agreeButton.tap()
        nextButton.tap()
        
        //Q4
        XCTAssert(stronglyAgreeButton.waitForExistence(timeout: 5))
        XCTAssert(stronglyAgreeButton.exists)
        XCTAssert(agreeButton.exists)
        XCTAssert(neutralButton.exists)
        XCTAssert(disagreeButton.exists)
        XCTAssert(stronglyDisagreeButton.exists)
        neutralButton.tap()
        nextButton.tap()
        
        //Q5
        XCTAssert(stronglyAgreeButton.waitForExistence(timeout: 5))
        XCTAssert(stronglyAgreeButton.exists)
        XCTAssert(agreeButton.exists)
        XCTAssert(neutralButton.exists)
        XCTAssert(disagreeButton.exists)
        XCTAssert(stronglyDisagreeButton.exists)
        
        
        //Finish the test
        stronglyDisagreeButton.tap()
        app.buttons["Done!"].tap()
        
        //Check if back at home screen
        XCTAssert(app.buttons["Wellness"].waitForExistence(timeout: 5))
        
    }
    
    //tests all input fields and buttons on Medication
    func testNavigationToMedication(){
        let app = XCUIApplication()
        loginToHomeScreen(app)
        
        //Navigate into meds home page
        XCTAssert(app.buttons["Medication"].waitForExistence(timeout: 5))
        app.buttons["Medication"].tap()
        
//        //Check medication graph
//        XCTAssert(app.buttons["MyMedsButton"].waitForExistence(timeout: 5))
//        app.buttons["MyMedsButton"].tap()
//
//        // TODO: Additional checks with medication graph
//
//        XCTAssert(app.buttons["MyLogButton"].waitForExistence(timeout: 5))
//        app.buttons["MyLogButton"].tap()
        
        //Navigate to add new medication plan
        XCTAssert(app.buttons["Add new"].exists)
        app.buttons["Add new"].tap()
        
        //Check under add new medication plan
        XCTAssert(app.textFields["Medication Name"].exists)
        
//        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 2).children(matching: .other).element
//        let stepper = element.children(matching: .stepper).element(boundBy: 0)
//        XCTAssert(stepper.buttons["Increment"].exists)
//        XCTAssert(stepper.buttons["Decrement"].exists)
//
//        let stepper2 = element.children(matching: .stepper).element(boundBy: 1)
//        XCTAssert(stepper2.buttons["Increment"].exists)
//        XCTAssert(stepper2.buttons["Decrement"].exists)
        
        
//        XCTAssert(app.buttons["monday"].exists)
//        XCTAssert(app.buttons["tuesday"].exists)
//        XCTAssert(app.buttons["wednesday"].exists)
//        XCTAssert(app.buttons["thursday"].exists)
//        XCTAssert(app.buttons["friday"].exists)
//        XCTAssert(app.buttons["saturday"].exists)
//        XCTAssert(app.buttons["sunday"].exists)
//        XCTAssert(app.textFields["00:00"].exists)
//        XCTAssert(app.buttons["Add"].exists)
//        XCTAssert(app.buttons["Cancel"].exists)
        
//        //Navigate back to meds plan home page
//        app.buttons["Cancel"].tap()
//        XCTAssert(app.buttons["Remove"].exists)
//        XCTAssert(app.buttons["Full med schedule"].exists)
//        XCTAssert(app.buttons["home white"].exists)
//        
//        //check for navigation back to home screen
//        app.buttons["home white"].tap()
//        XCTAssert(app.buttons["Medication"].waitForExistence(timeout: 5))
        
    }
    
    // tests all fields and buttons under options
    func testNavigationToOptions(){
        let app = XCUIApplication()
        loginToHomeScreen(app)
        
        let optionsButton = app.buttons["Options"]
        XCTAssert(optionsButton.waitForExistence(timeout: 5))
        optionsButton.tap()
        XCTAssert(app.buttons["home white"].exists)
        app.buttons["home white"].tap()
        XCTAssert(optionsButton.waitForExistence(timeout: 5))
        optionsButton.tap()
        app.buttons["LogoutButton"].tap()
                
        XCTAssert(app.textFields["Email"].exists)
    }
    //Basic UI test for connect UI view
    func testConnect(){
        let app = XCUIApplication()
        loginToHomeScreen(app)
        XCTAssert(app.buttons["Connect"].waitForExistence(timeout: 5))
        app.buttons["Connect"].tap()
        
        XCTAssert(app.buttons["addfriend"].exists)
        app.buttons["addfriend"].tap()
        XCTAssert(app.alerts["The Entered Email Does not Exist!"].buttons["Ok"].waitForExistence(timeout: 5))
        app.alerts["The Entered Email Does not Exist!"].buttons["Ok"].tap()
        
        XCTAssert(app.buttons["home white"].exists)
        app.textFields["Add new contact by email"].tap()
        app.textFields["Add new contact by email"].typeText("FAKEEMAIL@123.com\n")
        app.buttons["addfriend"].tap()
        app.alerts["The Entered Email Does not Exist!"].buttons["Ok"].tap()
        app.buttons["home white"].tap()
        XCTAssert(app.buttons["Options"].waitForExistence(timeout: 5))
        
        app.buttons["Connect"].tap()
        XCTAssert(app.buttons["addfriend"].exists)
        XCTAssert(app.buttons["home white"].exists)
        app.textFields["Add new contact by email"].tap()
        app.textFields["Add new contact by email"].typeText("unittestacc1@gmail.com\n")
        app.buttons["addfriend"].tap()
        app.alerts["You're already paired with unittestacc1@gmail.com"].buttons["Ok"].tap()
        app.buttons["home white"].tap()
        XCTAssert(app.buttons["Options"].waitForExistence(timeout: 5))
    }
    //test the scroll view in the profile for caregiver and patient
    func testProfileScrollView(){
        let app = XCUIApplication()
        loginToHomeScreen(app)
        
        XCTAssert(app.buttons["Profile"].waitForExistence(timeout: 5))
        app.buttons["Profile"].tap()
        
        XCTAssert(app.buttons["Save Button"].exists)
        let scrollViewsQuery = app.scrollViews
        let element = scrollViewsQuery.otherElements.containing(.image, identifier:"Menu BG").children(matching: .other).element
        element.swipeUp()
        
        let elementsQuery = scrollViewsQuery.otherElements
        let backButtonButton = elementsQuery.buttons["Back Button"]
        backButtonButton.tap()
        
        XCTAssert(app.buttons["Options"].waitForExistence(timeout: 5))
        app.buttons["Options"].tap()
        XCTAssert(app.buttons["LogoutButton"].waitForExistence(timeout: 5))
        app.buttons["LogoutButton"].tap()
        
        loginAsCaregiver(app)
        
        
        XCTAssert(app.buttons["CaregiverProfile"].waitForExistence(timeout: 5))
        app.buttons["CaregiverProfile"].tap()
        
        XCTAssert(app.textFields["First Name"].exists)
        XCTAssert(app.textFields["Last Name"].exists)
        XCTAssert(app.textFields["Email Name"].exists)
        XCTAssert(app.textFields["Date of Birth"].exists)
        XCTAssert(app.textFields["Cell"].exists)
        XCTAssert(app.textFields["Gender"].exists)
        XCTAssert(app.textFields["Address"].exists)
        XCTAssert(app.buttons["Save Button"].exists)
        XCTAssert(app.buttons["Back Button"].exists)
    }
    
    //test basic UI functionalities of SignUp
    func testSignUp(){
        
        let app = XCUIApplication()
        app.buttons["Sign up button"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .button).matching(identifier: "Button").element(boundBy: 0).tap()
        
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.textField, identifier:"First Name              Required").element.swipeUp()
        
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.buttons["Create account"].tap()
        app.alerts["Please Enter Your First Name"].buttons["Ok"].tap()
        elementsQuery.buttons["GO TO LOGIN"].tap()
        
    }
    
    func testNavigationtoMedWeekGraph()
    {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        app.buttons["Wellness"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Graph"].tap()
        elementsQuery.buttons["CogGame graph button"].tap()
    }
    
    func testNavigationtoMedMonthGraph()
    {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        app.buttons["Wellness"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Graph"].tap()
        elementsQuery.buttons["CogGame graph button"].tap()
        app.buttons["Month"].tap()
    }
    
    func testNavigationtoMedYearGraph()
    {
        let app = XCUIApplication()
        loginToHomeScreen(app)
        app.buttons["Wellness"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Graph"].tap()
        elementsQuery.buttons["CogGame graph button"].tap()
        app.buttons["Year"].tap()
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
