//
//  HomeScreenViewController.swift
//  UnHindr
//
//  Created by ata87 on 10/31/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import Foundation
import UIKit

class HomeScreenViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func WellnessTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Mood", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MoodViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func optionsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    
}
