/*
 File: [SettingsViewController.swift]
 Creators: [Jake, Jordan]
 Date created: [2/11/2019]
 Date updated: [3/11/2019]
 Updater name: [Jordan]
 File description: [Controls the functionality of the Options feature]
 */

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Transitions storyboard to Login screen, authenticates the logout with Firebase
    // Input:
    //      Logout button tapped
    // Output:
    //      1. Logout succesful: Switch from Settings to Login, authenticate Logout
    //      2. Logout failed: Print error message for failed logout
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out :%@", signOutError)
        }
        //Switch storyboard to the login screen
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
