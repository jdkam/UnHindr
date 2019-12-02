/*
 File: [WellnessTestHomeViewController.swift]
 Creators: [Lawrence]
 Date created: [19/11/2019]
 Date updated: [19/11/2019]
 Updater name: [Lawrence]
 File description: [Sends user to their corresponding graph controller]
 */

import UIKit

class WellnessGraphsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        Services.transitionHome(self)
    }
    
}
