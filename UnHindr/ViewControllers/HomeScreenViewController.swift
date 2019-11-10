/*
 File: [HomeScreenViewController]
 Creators: [Allan, Sina, Jordan]
 Date created: [31/10/2019]
 Date updated: [3/11/2019]
 Updater name: [Sina]
 File description: [Controls the Home Menu Navigation]
 */

import Foundation
import UIKit
import FirebaseAuth

class HomeScreenViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Transitions storyboard to Wellness Test screen
    // Input:
    //      Wellness Test button tapped
    // Output:
    //      Switch from Home Menu to Wellness Test
    @IBAction func WellnessTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "WellnessTestHome", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WellnessTestHomeViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Transitions storyboard to Options screen
    // Input:
    //      Options button tapped
    // Output:
    //      Switch from Home Menu to Options
    @IBAction func optionsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Transitions storyboard to Profile screen
    // Input:
    //      Profile button tapped
    // Output:
    //      Switch from Home Menu to Profile
    @IBAction func profileTapped(_ sender: UIButton) {
    }
    
    // MARK: - Transitions storyboard to Medication screen
    // Input:
    //      Medication button tapped
    // Output:
    //      Switch from Home Menu to Medication
    @IBAction func medicationTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Medication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mainTabController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
}
