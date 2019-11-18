/*
 File: [ModeChoiceViewController.swift]
 Creators: [Sina]
 Date created: [5/11/2019]
 Date updated: [10/11/2019]
 Updater name: [Sina]
 File description: [Creates a user mode for the user upon sign up]
 */

import UIKit

class ModeChoiceViewController: UIViewController {
    private var isPatient = 0
    
    // Input:
    //      1. Triggered by careGiver Button being tapped
    // Output:
    //      1. update the isPatient field to 0
    @IBAction func careGiverTapped(_ sender: UIButton) {
        self.isPatient = 0
    }
    
    // Input:
    //      1. Triggered by PD Button being tapped
    // Output:
    //      1. update the isPatient field to 1
    @IBAction func pdTapped(_ sender: UIButton) {
        self.isPatient = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
