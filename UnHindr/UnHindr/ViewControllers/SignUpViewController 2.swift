//
//  SignUpViewController.swift
//  UnHindr
//
//  Created by Allan on 2019-10-25.
//  Copyright © 2019 Sigma. All rights reserved.
//

//IMPORT FRAMEWORKS
import Foundation
import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    //Reference to Firebase database
    var ref: DatabaseReference!
    
    // MARK: - View Controller Lifecycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Load reference to database
        ref = Database.database().reference()

    }
    
    // MARK: - Functions for user signup
    // Function: Adding new user to Firebase Database
    // Input:
    //      1. Username
    //      2. Email
    //      3. Password
    // Output:
    //      N/A
    private func addToDatabase(){
        guard let user = userNameTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        guard let email = userNameTextField.text else {
            return
        }
        
        sendToDatabase(username: user, email: email, pass: password)
    }
    
    // Function: Check the user input fields to see if they're valid
    // Input:
    //      1. Username
    //      2. Email
    //      3. Password
    //      4. Confirm Password
    // Output:
    //      1. Valid -> return nil
    //      2. Invalid -> return error message
    private func validateFields() -> String?{
        //Check if all fields are filled in
        if userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        //Check if password is secure
        if(!isPasswordValid(passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))){
            return "Please make sure password contains at least 8 characters, a special character and a number"
        }
        
        // Check if an email already exists
        //TODO:
        
        
        return nil
    }
    
    // Function: Check for password validity
    // Input:
    // Input:
    //      1. A string
    // Output:
    //      1. Boolean (T/F)
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    // Function:
    // Input:
    //      1. Username
    //      2. Email
    //      3. Password
    // Output:
    //      1. Add new user to Firebase
    private func sendToDatabase(username: String, email: String, pass: String){
        ref.childByAutoId().setValue(["email": email, "password": pass])
    }
    
    // MARK: - Segue functions for navigation to adjacent views
    // UI Component
    // Activation: When pressed
    // Action: Navigate to Login controller
    @IBAction func goToLoginTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            //There is something wrong with the fields
            //TODO: Popup for error and clear
        }
        else{
            let username = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let confirmPassword = confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if (password != confirmPassword){
                //TODO: Passwords do not match
            }
            
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, err) in
                //Check for errors
                if let err = err {
                    //more detailed message
//                    err.localizedDescription
                    //There was an error creating the user
                    print("Error creating user")
                }
                else{
                    // User created successfully, now storing username
//                    let db = Firestore.firestore()
                }
            }
        }
        
        
    }
    
}
