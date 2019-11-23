/*
 File: [LoginViewController.swift]
 Creators: [Wei]
 Date created: [14/11/2019]
 Date updated: [16/11/2019]
 Updater name: [Sina]
 File description: [Controls funcitonality of Sign Up process]
 */

import Foundation
import UIKit

class SignUpViewController: UIViewController , UIPickerViewDataSource,UIPickerViewDelegate {

    //initializing outlets for all the text fields
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var cellTF: UITextField!
    //@IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UIButton!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passConfirmTF: UITextField!


    private var datePicker: UIDatePicker?
    var gender = ["Male", "Female", "Undefined"]
    var picker = UIPickerView()
    var isPatient = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        genderTF.inputView = picker

        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(SignUpViewController.dateChanged(datePicker:)),for: .valueChanged)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.viewTapped(gestureRecognizer:)))

        view.addGestureRecognizer(tapGesture)

        dateTF.inputView = datePicker
    }
  

    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTF.text = dateFormatter.string(from: datePicker.date)
    }

    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTF.text = gender[row]
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }

    @IBAction func createAccountTapped(_ sender: Any) {
        //let isFieldsComplete = self.validateFields()
        //if(isFieldsComplete){
            //store to DB and go to the home page
        //}
    }

    //input:
    //      1. None
    //output:
    //      1. true if all the required fields are filled in correctly
    //      2. else return false
    private func validateFields() -> Bool{
        if  firstNameTF.text == ""{
            Services.showAlert("Please Enter Your First Name", "", vc: self)
            return false
        }
        if (lastNameTF.text == ""){
            Services.showAlert("Please Enter Your Last Name", "", vc: self)
            return false
        }
        if (emailTF.text == ""){
            Services.showAlert("Please Enter Your email", "", vc: self)
            return false
        }
        if(dateTF.text == ""){
            Services.showAlert("Please Enter Your date of birth", "", vc: self)
            return false
        }
        if(passwordTF.text == " "){
            Services.showAlert("Please Enter Your password", "", vc: self)
            return false
        }else if( passwordTF.text != passConfirmTF.text){
            Services.showAlert("Passwords do not match", "", vc: self)
            return false
        }
        return true
    }
}
