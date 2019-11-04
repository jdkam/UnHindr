//
//  MedicationHomeViewController.swift
//  UnHindr
//
//  Created by Allan on 2019-11-03.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit

class MedicationHomeViewController: UIViewController {
    @IBOutlet weak var MedicineLabel: UILabel!
    @IBOutlet weak var DosageLabel: UILabel!
    @IBOutlet weak var QuantityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func CheckTapped(_ sender: UIButton) {
    }
    
    @IBAction func CancelTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func goToHomeTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }

}
