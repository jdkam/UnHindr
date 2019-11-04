//
//  MedicationViewController.swift
//  UnHindr
//
//  Created by Jakeb Puffer  on 10/29/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase


class MedicationViewController: UIViewController {
    @IBOutlet weak var checkMon: UIImageView!
    @IBOutlet weak var checkTues: UIImageView!
    @IBOutlet weak var checkWed: UIImageView!
    @IBOutlet weak var checkThur: UIImageView!
    @IBOutlet weak var checkFri: UIImageView!
    @IBOutlet weak var checkSat: UIImageView!
    @IBOutlet weak var checkSun: UIImageView!
    @IBOutlet weak var medFieldName: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var timeInputTextField: UITextField!
    
    
    // Store user object from authentication
    private var user: User?
    private var dayOFWeek: [String:Int] = ["Sunday":0, "Saturday":0, "Friday":0, "Thursday":0, "Wednesday":0, "Tuesday":0, "Monday":0]
    private var Dosage = 0
    private var Quantity = 0
    private var MedicationName = ""
    private var ReminderTime = ""
    private var timePicker: UIDatePicker?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkMon.alpha = 0
        checkTues.alpha = 0
        checkWed.alpha = 0
        checkThur.alpha = 0
        checkFri.alpha = 0
        checkSat.alpha = 0
        checkSun.alpha = 0
        
        configureMedNameText()
        configureTapGesture()
        
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(MedicationViewController.timeChanged(timePicker:)), for: .valueChanged)
        
        timeInputTextField.inputView = timePicker
        // Create authentication listeneing handler
        Services.handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.user = user
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Delete authentication handler
        Auth.auth().removeStateDidChangeListener(Services.handle!)
    }
    
    
    // MARK - Stores the medication data to the database
    // Input: None
    // Output:
    //      1. User's medication data is persistently stored in database
    private func storeToDB(){
        //User should be logged in with reference created
        // Add a new document with a generated id.
        let daysArr = initArrayToPassDays()
        self.MedicationName = medFieldName.text!
        print(daysArr)
        var ref: DocumentReference? = nil
        ref = Services.db.collection("users").document(Services.userRef).collection("MedicationPlan").addDocument(data: [
            "Dosage": self.Dosage,
            "Medication": self.MedicationName,
            "Quantity": self.Quantity,
            "ReminderTime": self.ReminderTime,
            "Day" : daysArr
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    // MARK - Extract the days of week to store for the medication
    // Input: None
    // Output:
    //      1. return an array filled with days of week chosen for medication
    private func initArrayToPassDays()-> Array<String>{
        let temp = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        var retArr = [String]()
        for days in temp {
            if (self.dayOFWeek[days] == 1){
                retArr.append(days)
            }
        }
        return retArr
    }
    
    
    private func configureMedNameText(){
        medFieldName.delegate = self
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MedicationViewController.handleTapOutsideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func timeChanged(timePicker: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
         self.ReminderTime = timeFormatter.string(from: timePicker.date)
         timeInputTextField.text = self.ReminderTime
    }
    
    @objc func handleTapOutsideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func monButtonTapped(_ sender: Any) {
        if (checkMon.alpha == 1){
            checkMon.alpha = 0
            self.dayOFWeek["Monday"] = 0
        }
        else {
            checkMon.alpha = 1
            self.dayOFWeek["Monday"] = 1
        }
        view.endEditing(true)
    }
    @IBAction func tuesButtonTapped(_ sender: Any) {
        if (checkTues.alpha == 1){
            checkTues.alpha = 0
            self.dayOFWeek["Tuesday"] = 0
        }
        else {
            checkTues.alpha = 1
            self.dayOFWeek["Tuesday"] = 1
        }
        view.endEditing(true)
    }
    @IBAction func wedButtonTapped(_ sender: Any) {
        if (checkWed.alpha == 1){
            checkWed.alpha = 0
            self.dayOFWeek["Wednesday"] = 0
        }
        else {
            checkWed.alpha = 1
             self.dayOFWeek["Wednesday"] = 1
        }
        view.endEditing(true)
    }
    @IBAction func thursButtonPressed(_ sender: Any) {
        if (checkThur.alpha == 1){
            checkThur.alpha = 0
            self.dayOFWeek["Thursday"] = 0
        }
        else {
            checkThur.alpha = 1
            self.dayOFWeek["Thursday"] = 1
        }
        view.endEditing(true)
    }
    @IBAction func friButtonPressed(_ sender: Any) {
        if (checkFri.alpha == 1){
            checkFri.alpha = 0
            self.dayOFWeek["Friday"] = 0
        }
        else {
            checkFri.alpha = 1
            self.dayOFWeek["Friday"] = 1
        }
        view.endEditing(true)
    }
    @IBAction func satButtonPressed(_ sender: Any) {
        if (checkSat.alpha == 1){
            checkSat.alpha = 0
            self.dayOFWeek["Saturday"] = 0
        }
        else {
            checkSat.alpha = 1
            self.dayOFWeek["Saturday"] = 1

        }
        view.endEditing(true)
    }
    @IBAction func sunButtonPressed(_ sender: Any) {
        if (checkSun.alpha == 1){
            checkSun.alpha = 0
            self.dayOFWeek["Sunday"] = 0
        }
        else {
            checkSun.alpha = 1
            self.dayOFWeek["Sunday"] = 1
        }
        view.endEditing(true)
    }
    @IBAction func addMedTapped(_ sender: Any) {
        self.storeToDB()
        view.endEditing(true)
    }
    @IBAction func cancelMedTapped(_ sender: Any) {
        //go back to med screen
        view.endEditing(true)
    }

    @IBAction func dosageStepper(_ sender: UIStepper) {
        self.Dosage = Int(sender.value)
        dosageLabel.text = String(self.Dosage)
        view.endEditing(true)
    }
    

    @IBAction func quantityStepper(_ sender: UIStepper) {
        self.Quantity = Int(sender.value)
        quantityLabel.text = String(self.Quantity)
        view.endEditing(true)
    }

}

extension MedicationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
