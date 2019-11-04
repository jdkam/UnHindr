//
//  ProfileViewController.swift
//  UnHindr
//
//  Created by Sina Ahmadian Behrouz on 11/2/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var FirstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var gendreTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cellTF: UITextField!
    
    private var datacollection: [String: Any]? = [:]
    var FirstName = "Bob"
    var LastName = "Smith"
    var Email = "bs@gmail.com"
    var Dob = DateComponents(calendar: Calendar.current, year: 1990, month: 08, day: 01)
    var gender = 0 //0 female , 1 men , 2 undecided
    var Address = "888 university drive"
    var City = "Burnaby"
    var Country = "Canada"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirstnameText()
        configureLastnameText()
        configureEmailText()
        configureDOBText()
        configureGenderText()
        configureAddressText()
        configureCityText()
        configureCountryText()
        configureCellText()
        configureTapGesture()
    }
    
    // MARK: - Update the user data fields with retrieved data from DB
    // Input:
    //      1. animated: A boolean to whether animate the changes
    // Output:
    //      1. User data validated and updated into data fields
    override func viewWillAppear(_ animated: Bool) {
        if (Services.userRef != nil) {
            self.getUserInfo(Services.userRef!, completionHandler: { (complete) in
                if complete == true {
                    self.addressTF.text = self.datacollection!["address"] as? String
                    self.FirstNameTF.text = self.datacollection!["firstName"] as? String
                    self.lastNameTF.text = self.datacollection!["lastName"] as? String
                    self.emailTF.text = self.datacollection!["email"] as? String
                    self.cellTF.text = self.datacollection!["cell"] as? String
                    self.addressTF.text = self.datacollection!["address"] as? String
                    self.cityTF.text = self.datacollection!["city"] as? String
                    self.countryTF.text = self.datacollection!["country"] as? String

                    
                    // Obtain the firebase dob field as a string
                    let extractedDob = self.datacollection!["dob"] as! Timestamp
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let convertedDate = formatter.string(from: extractedDob.dateValue())
                    let date1 = formatter.date(from: convertedDate)
                    formatter.dateFormat = "dd-MMM-yyyy"
                    let intuitiveDate = formatter.string(from:date1!)
                    self.dobTF.text = intuitiveDate
                    
                    
                    //determine the gender
                    if(self.datacollection!["gender"] as? Int == 0){
                        self.gendreTF.text = "Female"
                    }else if (self.datacollection!["gender"] as? Int == 1){
                        self.gendreTF.text = "Male"
                    }else{
                        self.gendreTF.text = "Undecided"
                    }
                }
                else{
                    print("----------------Failed to get user data--------------")
                }
                
            })
        }
    }

    
    // MARK: - Retrieve reference to a patient's data
    // Input:
    //      1. unique UID of a user
    // Output:
    //      1. Reference to user data
    func getUserInfo(_ userdoc: String, completionHandler: @escaping (_ result: Bool? ) -> Void){
        Services.db.collection("users").document(userdoc).addSnapshotListener { (documentSnapshot, error) in
            
            if error != nil {
                //error
            }
            else{
                guard let document = documentSnapshot else {
                    print("Error fetching user document")
                    return
                }
                self.datacollection = document.data()
                let result = true
                completionHandler(result)
            }
            
        }
    }
    
    // MARK: - Send flow back to the Home Screen
    // Input: None
    // Output:
    //      1. The user is at the Home Screen now
    @IBAction func backTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Update and Store user data
    // Input: None
    // Output:
    //      1. The user's data is persistently stored
    @IBAction func saveTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Allows the text field to use the extension function textFieldShouldReturn()
    // Input:
    //      None
    // Output:
    //      Allows the text field to use the extension function textFieldShouldReturn()
    private func configureFirstnameText(){
        FirstNameTF.delegate = self
    }
    
    // MARK: - Allows the text field to use the extension function textFieldShouldReturn()
    // Input:
    //      None
    // Output:
    //      Allows the text field to use the extension function textFieldShouldReturn()
    private func configureLastnameText(){
        lastNameTF.delegate = self
    }
    
    // MARK: - Allows the text field to use the extension function textFieldShouldReturn()
    // Input:
    //      None
    // Output:
    //      Allows the text field to use the extension function textFieldShouldReturn()
    private func configureEmailText(){
        emailTF.delegate = self
    }
    
    // MARK: - Allows the text field to use the extension function textFieldShouldReturn()
    // Input:
    //      None
    // Output:
    //      Allows the text field to use the extension function textFieldShouldReturn()
    private func configureDOBText(){
        dobTF.delegate = self
    }
    
    // MARK: - Allows the text field to use the extension function textFieldShouldReturn()
    // Input:
    //      None
    // Output:
    //      Allows the text field to use the extension function textFieldShouldReturn()
    private func configureGenderText(){
        gendreTF.delegate = self
    }
    
    // MARK: - Allows the text field to use the extension function textFieldShouldReturn()
    // Input:
    //      None
    // Output:
    //      Allows the text field to use the extension function textFieldShouldReturn()
    private func configureAddressText(){
        addressTF.delegate = self
    }
    
    // MARK: - Allows the text field to use the extension function textFieldShouldReturn()
    // Input:
    //      None
    // Output:
    //      Allows the text field to use the extension function textFieldShouldReturn()
    private func configureCityText(){
        cityTF.delegate = self
    }
    
    // MARK: - Allows the text field to use the extension function textFieldShouldReturn()
    // Input:
    //      None
    // Output:
    //      Allows the text field to use the extension function textFieldShouldReturn()
    private func configureCountryText(){
        countryTF.delegate = self
    }
    
    // MARK: - Allows the text field to use the extension function textFieldShouldReturn()
    // Input:
    //      None
    // Output:
    //      Allows the text field to use the extension function textFieldShouldReturn()
    private func configureCellText(){
        cellTF.delegate = self
    }
    
    // MARK: - Enables a tap outside of the keyboard to call handleTapOutsideKeyboard()
    // Input:
    //      None
    // Output:
    //      Enables a tap outside of the keyboard to call handleTapOutsideKeyboard()
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleTapOutsideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Causes the keyboard to be dismissed
    // Input:
    //      None
    // Output:
    //      Causes the keyboard to be dismissed
    @objc func handleTapOutsideKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - Allows the return button in the keyboard to dismiss the keyboard
// Input:
//      None
// Output:
//      Allows the return button in the keyboard to dismiss the keyboard
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
