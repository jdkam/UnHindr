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
import FirebaseDatabase

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
    
}
