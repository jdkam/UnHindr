//
//  HomeScreenViewController.swift
//  UnHindr
//
//  Created by ata87 on 10/31/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeScreenViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Services.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            Services.getDBUserRef(user, completionHandler: { (userref) in
                guard let userref = userref else {
                    print("Unable to get user reference")
                    return
                }
                Services.userRef = userref
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(Services.handle!)
    }
    
    @IBAction func WellnessTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Mood", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MoodViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    
    
}
