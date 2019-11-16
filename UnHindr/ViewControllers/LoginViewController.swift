/*
 File: [LoginViewController.swift]
 Creators: [Allan, Jake]
 Date created: [28/10/2019]
 Date updated: [15/11/2019]
 Updater name: [Sina]
 File description: [Controls funcitonality of the Login screen]
 */

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    //used to navigate user to the correct homescreen
    private var isPatinet = 0
    // to determine which button is pressed (login/signup) - used in viewWillDisappear
    private var isSignUp = 0
    //place holder for users data
    private var datacollection: [String: Any]? = [:]
    
    // MARK: - Outlets
    //Input fields for username and password
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureEmailText()
        configurePasswordText()
        configureTapGesture()
    }
    
    //Mark: Destructor for the view
    // Input:
    //      1. animated: to output the results
    // Output:
    //      1. Configure user info upon log in
    override func viewWillDisappear(_ animated: Bool) {
        if(isSignUp==0){
            //without isSignUp check the code crashes when sign up is pressed because it will run the below code below and its missing some backend stuff thats being done when log in is tapped and all
            Auth.auth().removeStateDidChangeListener(Services.handle!)
        }

    }
    
    // MARK: - Database methods for login authentication
    // Backend Function
    // Input:
    //      1. Email
    //      2. Password
    // Output:
    //      1. Signin successful -> Navigate to home menu
    //      2. Signin unsuccessful -> Display an error message
    private func authenticateLogin(){
        guard let email = self.emailTextField.text, let password = self.passwordTextField.text else {
            print("Email and password fields are empty")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if error != nil {
                print("Error with authentication")
                return
            }
            Services.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                Services.getDBUserRef(user, completionHandler: { (userref) in
                    guard let userref = userref else {
                        print("Unable to get user reference")
                        return
                    }
                    Services.userRef = userref
                })
            }
            strongSelf.transitionToHomeScreen()
            
        }
    }
    
    // MARK: - Allows the text field to use the extension function textFieldShouldReturn()
    // Input:
    //      None
    // Output:
    //      Allows the text field to use the extension function textFieldShouldReturn()
    private func configureEmailText(){
        emailTextField.delegate = self
    }
    
    // MARK: - Allows the text field to use the extension function textFieldShouldReturn()
    // Input:
    //      None
    // Output:
    //      Allows the text field to use the extension function textFieldShouldReturn()
    private func configurePasswordText(){
        passwordTextField.delegate = self
    }
    
    // MARK: - Enables a tap outside of the keyboard to call handleTapOutsideKeyboard()
    // Input:
    //      None
    // Output:
    //      Enables a tap outside of the keyboard to call handleTapOutsideKeyboard()
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTapOutsideKeyboard))
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

    
    // MARK - Changes storyboard and view controller to the home screen
    // Input: None
    // Output:
    //      1. Storyboard changes to HomeScreen and displays first view on the storyboard
    private func transitionToHomeScreen(){
        if(self.isPatinet == 0){
            //Switch storyboard to the home menu
            let storyboard = UIStoryboard(name: "CaregiverHomeScreen", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CaregiverHomeScreenViewController") as UIViewController
            present(vc, animated: true, completion: nil)
        }else{
            //Switch storyboard to the home menu
            let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
            present(vc, animated: true, completion: nil)
        }

    }
    
    // MARK: - Segue functions for navigation to adjacent views
    // UI Component
    // Activation: When pressed
    // Action: If successful -> Navigate to home menu
    //         else not successful -> display error message
    @IBAction func loginTapped(_ sender: Any) {
        if (Services.userRef != nil) {
            self.getUserInfo(Services.userRef!, completionHandler: { (complete) in
                if complete == true {
                    self.isPatinet = (self.datacollection?["IsPatient"] as? Int)!
                }
                else{
                    print("----------------Failed to get user data--------------")
                }
                
            })
        }
        authenticateLogin()
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
    
    // MARK: - Segue functions for navigation to adjacent views
    // UI Component
    // Activation: When pressed
    // Action: If successful -> Navigate to ModeChoice
    @IBAction func signUpTapped(_ sender: UIButton) {
        self.isSignUp = 1
        let storyboard = UIStoryboard(name: "ModeChoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ModeChoiceViewController") as UIViewController
        present(vc, animated: true, completion: nil)

    }
    
}

// MARK: - Allows the return button in the keyboard to dismiss the keyboard
// Input:
//      None
// Output:
//      Allows the return button in the keyboard to dismiss the keyboard
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
