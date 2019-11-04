/*
 File: [MedicationHomeViewController.swift]
 Creators: [Allan, Jordan]
 Date created: [03/11/2019]
 Date updated: [03/11/2019]
 Updater name: [Jordan]
 File description: [Controls the MyMeds screen in UnHindr]
 */

import UIKit

class MedicationHomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Transitions storyboard to Home Menu
    // Input:
    //      Home button tapped
    // Output:
    //      Switch from Medication to Home menu
    @IBAction func goToHomeTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
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
