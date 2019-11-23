/*
 File: [EmergencyContactViewController.swift]
 Creators: [Allan, Jake]
 Date created: [23/11/2019]
 Date updated: [23/11/2019]
 Updater name: [Jake]
 File description: [Controls funcitonality of the Emergency Contact screen]
 */

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class EmergencyContactViewController: UIViewController {
    
    var timer = Timer()
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        //Creates the timer to increment every 1 second.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true )
    }
    
    @objc func timerAction(){
        
    }
    
}

