/*
 File: [Card.swift]
 Creators: [Jordan]
 Date created: [11/14/2019]
 Date updated: [11/15/2019]
 Updater name: [Jordan]
 File description: [Card custom class for specifying attributes of individual card items in the game]
 */

import Foundation

class Medication: NSObject {
    var medName: String
    var dosage: Int
    var quantity: Int
    var ReminderTime: String
    var Day: [String]
    
    init(medName: String, dosage: Int, quantity: Int, reminderTime: String, days: [String]) {
        self.medName = medName
        self.dosage = dosage
        self.quantity = quantity
        self.ReminderTime = reminderTime
        self.Day = days
    }
}
