//
//  ViewController.swift
//  UnHindr
//
//  Created by Allan on 2019-10-28.
//  Copyright © 2019 Sigma. All rights reserved.
//
import Foundation
import UIKit

class LoginViewController: UIViewController {
    // MARK: - Outlets
    //Input fields for username and password
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
//        //Switch storyboard to the home menu
        let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
        present(vc, animated: true, completion: nil)
//
    }

}

