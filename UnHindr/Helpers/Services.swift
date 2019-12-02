/*
 File: [Services.swift]
 Creators: [Allan]
 Date created: [29/10/2019]
 Date updated: [10/11/2019]
 Updater name: [Allan]
 File description: [Services file for database references]
 */

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth


class Services {
    
    // Store reference to current user's stored data
    static var userRef: String?
    
    // Handle for authentication changes
    static var handle: AuthStateDidChangeListenerHandle?
    
    // Static reference to Firestore root
    static let db = Firestore.firestore()
    
    // Reference to all users
    static let fullUserRef = db.collection("users")
    
//    // User profile reference
//    static var userProfileRef: DocumentReference?//db.collection("users").document(userRef!)
//
//    // Medication plan reference
    static let medPlanName = "MedicationPlan"
//    static var medicationPlanRef = db.collection("users").document(userRef!).collection("MedicationPlan")

//    // Medication history reference
    static let medHistoryName = "Medication"
//    static var medicationHistoryRef = db.collection("users").document(userRef!).collection("Medication")

//    // Connections reference
    static let connectionName = "Connections"
//    static var connectionRef = db.collection("users").document(userRef!).collection("Connections")

//    // Motor Game reference
    static let motorGameName = "MotorGameData"
//    static var motorGameRef = db.collection("users").document(userRef!).collection("MotorGameData")
    
    static let locationName = "Location"
    
    // Cognitive Game reference
    static let cogGameName = "CogGameData"
    
    // Mood reference
    static let moodName = "Mood"

    
    // MARK: - Retrieve reference to a patient's data
    // Input:
    //      1. unique UID of a user
    // Output:
    //      1. Reference to user data
    static func getDBUserRef(_ user: User?, completionHandler: @escaping(_ result: String?) -> Void) {
        var result: String!
        // fetch reference to specified user
        let uid = (user?.uid ?? "User instance is nil")
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print("Error getting user info")
                } else {
                    result = (querySnapshot!.documents[0].documentID)
                    completionHandler(result)
                }
        }
    }
    //Configures how the alert will be displayed to screen
    //input:
    //      1.Takes in a title and message parameter and displays alert to screen
    //output:
    //      1. output the alert to the screen
    static func showAlert(_ title:String, _ message: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func transitionHome(_ UIVC: UIViewController){
        Services.fetchModeStatus(Services.userRef!) { (result) in
            if (result!) {
                let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
                UIVC.present(vc, animated: true, completion: nil)
            }else{
                let storyboard = UIStoryboard(name: "CaregiverHomeScreen", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CaregiverHomeScreenViewController") as UIViewController
                UIVC.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    static func transitionHomeErrMsg(_ UIVC: UIViewController, errTitle: String, errMsg: String){
        Services.fetchModeStatus(Services.userRef!) { (result) in
            if (result!) {
                let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
                UIVC.present(vc, animated: true, completion: nil)
            }else{
                let storyboard = UIStoryboard(name: "CaregiverHomeScreen", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CaregiverHomeScreenViewController") as UIViewController
                UIVC.present(vc, animated: true, completion: nil)
            }
        }
        Services.showAlert(errTitle, errMsg, vc: UIVC)
    }
    
    
    // Fetch caregiver mode status using a completion handler
    // Input:
    //      1. User reference
    // Output:
    //      1. returns true if user is a patient else false
    static func fetchModeStatus(_ userdoc: String, completionHandler: @escaping (_ result: Bool? ) -> Void){
        fullUserRef.document(userRef!).getDocument { (documentSnapshot, err) in
            if err != nil {
                //error
            }
            else{
                guard let document = documentSnapshot else {
                    print("Error fetching user document")
                    return
                }
                
                let status = document.get("isPatient") as! Bool

                completionHandler(status)
            }
            
        }
    }
    
    //  Fetches the patient data from medication and medication plan
    //  Input:
    //      1. None
    //  Output:
    //      1. Returns the collection reference to the medication plan
    //      2. Returns the collection reference to the medication history
    static func checkUserIDMed() -> (CollectionReference,CollectionReference)
    {
        var medPlan: CollectionReference
        var medHistory: CollectionReference
        if (user_ID == "")
        {
            medPlan = Services.fullUserRef.document(Services.userRef!).collection(Services.medPlanName)
            medHistory = Services.fullUserRef.document(Services.userRef!).collection(Services.medHistoryName)
        }
        else
        {
            medPlan = Services.fullUserRef.document(user_ID).collection(Services.medPlanName)
            medHistory = Services.fullUserRef.document(user_ID).collection(Services.medHistoryName)
        }
        return (medPlan,medHistory)
    }
    
    // Checks whether the current logged in user is a patient or not
    // Input:
    //      1. None
    // Output:
    //      1. Returns true if user is a patient
    //      2. Returns false if user is a caregiver
    static func getisPatient(completionHandler: @escaping (_ result: Bool) -> Void)
    {
        Services.db.collection("users").whereField("email", isEqualTo: userEmail).whereField("isPatient", isEqualTo: true).getDocuments() {
            (querySnapshot,err) in
            if querySnapshot!.isEmpty {
                completionHandler(false)
            }
            else
            {
                completionHandler(true)
            }
        }
    }
    
    //  Fetches the patient's motor game data
    //  Input:
    //      1. None
    //  Output:
    //      1. Returns the collection reference to the motor game data
    static func checkUserIDMotorGame() -> CollectionReference
    {
        var motorRef: CollectionReference
        if (user_ID == "")
        {
            motorRef = Services.db.collection("users").document(Services.userRef!).collection(Services.motorGameName)
        }
        else
        {
            motorRef = Services.fullUserRef.document(user_ID).collection(Services.motorGameName)
        }
        return motorRef
    }
    
    //  Fetches the patient's cognitive game data
    //  Input:
    //      1. None
    //  Output:
    //      1. Returns the collcetion reference to the cognitive game data
    static func checkUserIDCogGame() -> CollectionReference
    {
        var cogRef: CollectionReference
        if (user_ID == "")
        {
            cogRef = Services.fullUserRef.document(Services.userRef!).collection(Services.cogGameName)
        }
        else{
            cogRef = Services.fullUserRef.document(user_ID).collection(Services.cogGameName)
        }
        return cogRef
    }
    
    //  Fetches the patient's mood data
    //  Input:
    //      1. None
    //  Output:
    //      1. Returns the collection reference to the mood data
    static func checkUserIDMood() -> CollectionReference
    {
        var moodRef: CollectionReference
        if(user_ID == "")
        {
            moodRef = Services.fullUserRef.document(Services.userRef!).collection(Services.moodName)
        }
        else
        {
            moodRef = Services.fullUserRef.document(user_ID).collection(Services.moodName)
        }
        return moodRef
    }
    
    // Fetches the documents for the patient
    //  Input:
    //      1. None
    //  Output:
    //      1. Returns the document reference of that specific user
    static func checkUserProfileID() -> DocumentReference
    {
        var userRef: DocumentReference
        if(user_ID == "")
        {
            userRef = Services.fullUserRef.document(Services.userRef!)
        }
        else
        {
            userRef = Services.fullUserRef.document(user_ID)
        }
        return userRef
    }
    
    // MARK: - Configures local notifications for the Medication and calls NotificationManager methods to schedule the notifications
    // Input:
    //      Name of the medication, an array of strings containing the days for natifications, and the time for notifications in HH:MM 24-hour format
    // Output:
    //      Local notifications for medication are scheduled for the specified time and days
    static func setMedNotifications(medName: String, daysArr: [String], medTime: String) {
        
        let manager = NotificationManager()
        
        var sendingDate = Date()
        
        let currentWeekday = Calendar.current.component(.weekday, from: sendingDate)
        var dayNum = 0
        
        var arr = medTime.components(separatedBy: [":"])
        let notifHour = Int(arr[0])
        let notifMinute = Int(arr[1])
        
        for day in daysArr{
            switch day {
            case "Sunday":
                sendingDate = Date.today().next(.Sunday)
                dayNum = 1
            case "Monday":
                sendingDate = Date.today().next(.Monday)
                dayNum = 2
            case "Tuesday":
                sendingDate = Date.today().next(.Tuesday)
                dayNum = 3
            case "Wednesday":
                sendingDate = Date.today().next(.Wednesday)
                dayNum = 4
            case "Thursday":
                sendingDate = Date.today().next(.Thursday)
                dayNum = 5
            case "Friday":
                sendingDate = Date.today().next(.Friday)
                dayNum = 6
            case "Saturday":
                sendingDate = Date.today().next(.Saturday)
                dayNum = 7
            default:
                print("ERROR: INVALID DAY")
            }
            if (dayNum == currentWeekday) {
                sendingDate = Date.today()
            }
            
            let components = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: sendingDate)
            manager.notifications.append(NotificationStruct(id: "\(medName) - \(day)", title: medName, datetime: DateComponents(calendar: Calendar.current, year: components.year, month: components.month, day: components.day, hour: notifHour, minute: notifMinute)))
            
        }
        
        manager.schedule()
    }
}

extension Date {
    enum Weekday: String, CaseIterable {
        case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
        
        static var asArray: [Weekday] {
            return self.allCases
        }
        
        func asInt() -> Int {
            return Weekday.asArray.firstIndex(of: self)!
        }
    }
    
    static func isToday(_ timestamp: Timestamp) -> Bool {
        return Calendar.current.isDateInToday(timestamp.dateValue())
    }
    
    static func getDayOfWeek(_ timestamp: Timestamp) -> Date.Weekday {
        // Get date of week from NSDate value
        print("Timestamp: \(timestamp.dateValue())")
        let index = Calendar.current.component(.weekday, from: timestamp.dateValue())
        print("Date of week \(index)")
        return Weekday.asArray[index-1]
    }
    
    
    //The following code was taken from Stack Overflow: written by Sandeep, https://stackoverflow.com/questions/33397101/how-to-get-mondays-date-of-the-current-week-in-swift
    //Code's purpose is to return date and timestamp of next weekday in the future
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue.lowercased()
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}
