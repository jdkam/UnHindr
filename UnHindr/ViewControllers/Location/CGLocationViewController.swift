//
//  CGLocationViewController.swift
//  UnHindr
//
//  Created by Sina Behrouz on 2019-11-30.
//  Copyright © 2019 Sigma. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class CGLocationViewController: UIViewController {
    private var longitude = 0.0
    private var latitude  = 0.0
    var locationSnapshot: QuerySnapshot? // locationSnapshot?.documents[0].documentID

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /***grab the query of the user***/
        
        if(user_ID == ""){
            print("*****")
            print("userID is null" )
            Services.transitionHomeErrMsg(self, errTitle: "PleasePick a User", errMsg: "")
        }else{
            print("USER_ID DOES NOT EQUAL NULL")
            print(user_ID)
            //at this point we have the user ref
            getLocationDoc(user_ID) { (ret) in
                if !ret {
                    print("Failed to load location data")
                }else{
                    let docID = self.locationSnapshot?.documents[0].documentID
                    let ref = Services.db.collection("users").document(user_ID).collection("Location").document(docID!)
                    
                    for document in self.locationSnapshot!.documents{
                        self.latitude = document.get("latitude") as! Double
                        self.longitude = document.get("longitude") as! Double
                        print("*****")
                        print(self.latitude)
                        print(self.longitude)
                        print("*****")
                    }
                }
            }
        }
        /**********/
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    // Input:
    //      1. UserRef: unique user id
    //      2. CompletionHandler
    // Output:
    //      1. grabs the document id for user's location
    func getLocationDoc(_ userRef: String, completionHandler: @escaping (Bool) -> Void) {
        Services.fullUserRef.document(userRef).collection(Services.locationName).getDocuments { (querySnapshot, err) in
            if (err != nil){
                //error
            }
            else {
                self.locationSnapshot = querySnapshot
                completionHandler(true)
            }
        }
    }
    
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        Services.transitionHome(self)
    }
    
    
}
