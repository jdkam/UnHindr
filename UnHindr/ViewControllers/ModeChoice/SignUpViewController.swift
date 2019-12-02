/*
 File: [LoginViewController.swift]
 Creators: [Wei]
 Date created: [14/11/2019]
 Date updated: [16/11/2019]
 Updater name: [Sina]
 Class description: [Controls funcitonality of Sign Up process]
 */

import Foundation
import UIKit
import FirebaseAuth
import Firebase
class SignUpViewController: UIViewController , UIPickerViewDataSource,UIPickerViewDelegate {

    //initializing outlets for all the text fields
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var cellTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passConfirmTF: UITextField!

    private var datePicker: UIDatePicker?
    var gender = ["Male", "Female", "Undefined"]
    var picker = UIPickerView()
    //isPatient will be set by ModeChoice Screen
    var isPatient = false
    var UID = ""
    
    
    //initializes button and field functionality
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

    // Function that attempts to sign up new users
    // Input:
    //      1. Creat Account Tapped
    // Output:
    //      1. Creates an account for the requesting user and navigate to Login
    //         else display error
    @IBAction func createAccountTapped(_ sender: Any) {
        let isFieldsComplete = self.validateFields()
        if(isFieldsComplete == true){
            let ToPassEmail: String = emailTF.text!
            let toPassPassword: String = passwordTF.text!
            self.signUpNewUser(email: ToPassEmail, password: toPassPassword) { (success) in
                if(!success){
                    Services.showAlert("Unable to create an account at this time", "Please Try again later", vc: self)
                }else{
                    //add the user to user info
                    let yourDate = self.dateTF.text
                    let dfmatter = DateFormatter()
                    dfmatter.dateFormat = "MM/dd/yyyy"
                    let date = dfmatter.date(from: yourDate!)
                    
                    var genderTemp: Int = 0
                    if(self.genderTF.text == "Male"){
                        genderTemp = 0
                    }else if (self.genderTF.text == "Female"){
                        genderTemp = 1
                    }else{genderTemp = 2}

                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName": self.firstNameTF.text!,
                                                              "lastName": self.lastNameTF.text!,
                                                              "email": self.emailTF.text!,
                                                              "cell": self.cellTF.text!,
                                                              "address": self.addressTF.text!,
                                                              "country": self.countryTF.text!,
                                                              "city": self.cityTF.text!,
                                                              "gender": genderTemp,
                                                              "isPatient": self.isPatient,
                                                              "dob": date!,
                                                              "uid": self.UID,
                                                              "MedPlan": [],
                                                              "MedPlanTimestamp": Timestamp.init(),
                                                              "MedHistoryTimestamp":
                                                              Timestamp.init()
                                                              ])
                    //go back to login
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Function that attempts to sign up new users
    // Input:
    //      1. Valid email
    //      2. Valid password
    // Output:
    //      1. True -> User has successfully signed up
    //      2. False -> error signing up user
    func signUpNewUser(email: String, password: String, completionHandler: @escaping (Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, err) in
            if err != nil {
                print("Error creating new user: \(String(describing: err))")
                completionHandler(false)
            }
            else {
                self.UID = (authResult?.user.uid)!
                completionHandler(true)
            }
        }
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
        if(passwordTF.text == ""){
            Services.showAlert("Please Enter Your password", "", vc: self)
            return false
        }else if( passwordTF.text != passConfirmTF.text){
            Services.showAlert("Passwords do not match", "", vc: self)
            return false
        }else if ( (passwordTF.text?.count)! < 6){
            Services.showAlert("Passwords Must be at least 6 characters", "", vc: self)
            return false
        }
        return true
    }
}
