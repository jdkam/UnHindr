/*
 File: [ModeChoiceViewController.swift]
 Creators: [Sina]
 Date created: [5/11/2019]
 Date updated: [10/11/2019]
 Updater name: [Sina]
 Class description: [Creates a user mode for the user upon sign up]
 */

import UIKit

class ModeChoiceViewController: UIViewController {
    private var isPatient = false
    
    // Input:
    //      1. Triggered by careGiver Button being tapped
    // Output:
    //      1. update the isPatient field to 0
    @IBAction func careGiverTapped(_ sender: UIButton) {
        self.isPatient = false
        performSegue(withIdentifier: "GoToSignUp", sender: self)
    }
    
    // Input:
    //      1. Triggered by PD Button being tapped
    // Output:
    //      1. update the isPatient field to 1
    @IBAction func pdTapped(_ sender: UIButton) {
        self.isPatient = true
        performSegue(withIdentifier: "GoToSignUp", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Segue to transition to next controller
    // Input: None
    // Output:
    //      1. Q4 view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GoToSignUp"){
            let vc = segue.destination as! SignUpViewController
            vc.isPatient = self.isPatient
        }

    }
}
