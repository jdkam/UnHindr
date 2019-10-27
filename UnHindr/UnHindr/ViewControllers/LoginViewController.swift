//
//  LoginViewController.swift
//  UnHindr
//
//  Created by Allan on 2019-10-24.
//  Copyright © 2019 Sigma. All rights reserved.
//

// IMPORT FRAMEWORKS
import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth


class LoginViewController: UIViewController {
    // MARK: - Outlets
    //Input fields for username and password
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Reference to FireBase Database
    var ref: DatabaseReference!
    
    // MARK: - View controller lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load references to Firebase
        ref = Database.database().reference()
        
    }
    
    // MARK: - Database methods for login authentication
    // Backend Function
    // Input:
    //      1. Email
    //      2. Password
    // Output:
    //      1. Signin successful -> Navigate to home menu
    //      2. Signin unsuccessful -> Display an error message
    func authenticateLogin(){
        
    }
    
    // MARK: - Segue functions for navigation to adjacent views
    // UI Component
    // Activation: When pressed
    // Action: If successful -> Navigate to home menu
    //         else not successful -> display error message
    @IBAction func loginTapped(_ sender: Any) {
        //Push in new view controller for the home menu
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let MainNavigationVC = mainStoryboard.instantiateViewController(identifier: "MainNavigationController") as? MainNavigationController else {
            return
        }
        present(MainNavigationVC, animated: true, completion: nil)
    }
    
    
}


