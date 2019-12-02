/*
 File: [CaregiverHomeScreenViewController.swift]
 Creators: [Sina]
 Date created: [14/11/2019]
 Date updated: [14/11/2019]
 Updater name: [Sina]
 Class description: [Controls the Home Menu for CareGiver]
 */

import UIKit

class CaregiverHomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func noPatientSelected(_ sender: Any)
    {
        if(user_ID == "")
        {
            Services.showAlert("No Patient Selected", "Please go back to the Connect screen and select a patient.", vc: self)
        }
    }
    
}
