/*
 File: [Medication.swift]
 Creators: [Allan]
 Date created: [11/14/2019]
 Date updated: [11/30/2019]
 Updater name: [Allan]
 Class description: [Custom medication class that defines each instance of a medication plan]
 */

import Foundation

/// Medication class for defining the data structure of each medication plan
class Medication: NSObject {
    var medName: String
    var dosage: Int
    var quantity: Int
    var ReminderTime: String
    var Day: [String]
    
    // Constructor that fills in the class
    init(medName: String, dosage: Int, quantity: Int, reminderTime: String, days: [String]) {
        self.medName = medName
        self.dosage = dosage
        self.quantity = quantity
        self.ReminderTime = reminderTime
        self.Day = days
    }
}
