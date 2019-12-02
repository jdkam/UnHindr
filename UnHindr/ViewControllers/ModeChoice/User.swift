/*
 File: [User.swift]
 Creators: [Jordan]
 Date created: [11/21/2019]
 Date updated: [11/22/2019]
 Updater name: [Sina]
 Class description: [contains information about each user's personal data]
 */

import Foundation

class UserClass {
//    //user information
    var firstName: String = ""
    var lastName: String = ""
    var cell: String = ""
    var email: String = ""
    var gender: Int = 0
    var isPatient: Bool = false
    var city: String = ""
    var country: String = ""
    var address: String = ""
    UserClass() {
        firstName = "XXX"
        lastName = "XXX"
        self.cell = "XXX-XXX-XXXX"
        self.email = "XXX@gmail.com"
        self.gender = 1
        self.isPatient = false
        self.city = "XXX"
        self.country = "XXX
        self.address = "XXX"
    }
    
}
