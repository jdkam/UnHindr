//
//  testViewController.swift
//  UnHindr
//
//  Created by Sina Ahmadian Behrouz on 11/2/19.
//  Copyright © 2019 Sigma. All rights reserved.
//
import UIKit
import Foundation
import FirebaseFirestore

class testViewController: UIViewController {
    
    var Email = "###################EMPTY*************************"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserInfo(Services.userRef) { (result) in
            guard let result = result else {
                print("Unable to fetch")
                return
            }
            
            
        }
    }

    func getUserInfo(_ userdoc: String, completionHandler: @escaping (_ result: Bool? ) -> Void){
        Services.db.collection("users").document(userdoc).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching user document")
                return
            }
            self.Email = document.get("email") as! String
            completionHandler(true)
        }
    }

}
