//
//  MoodQ5ViewController.swift
//  UnHindr
//
//  Created by Sina Ahmadian Behrouz on 11/1/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase

class MoodQ5ViewController: UIViewController {
    // Private variables to keep track of scores
    private var score = 0
    var prevScore = 0
    
    // Store user object from authentication
    private var user: User?
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.score = self.prevScore
        clearAllButtonBackgrounds()
        
        Services.handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.user = user
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(Services.handle!)
    }
    
    // MARK: - Visual effects on the choice buttons
    // Backend Function
    // Input: None
    // Output:
    //      1.The choice buttons now contain a white background
    func clearAllButtonBackgrounds(){
        SAB.backgroundColor = UIColor.white
        AB.backgroundColor = UIColor.white
        NB.backgroundColor = UIColor.white
        DB.backgroundColor = UIColor.white
        SDB.backgroundColor = UIColor.white
    }
    
    @IBOutlet weak var SAB: UIButton!
    @IBOutlet weak var AB: UIButton!
    @IBOutlet weak var NB: UIButton!
    @IBOutlet weak var DB: UIButton!
    @IBOutlet weak var SDB: UIButton!
    
    @IBAction func SApressed(_ sender: UIButton) {
        score = prevScore + 5
        clearAllButtonBackgrounds()
        SAB.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func Apressed(_ sender: UIButton) {
        score = prevScore + 4
        clearAllButtonBackgrounds()
        AB.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func Npressed(_ sender: UIButton) {
        score = prevScore + 3
        clearAllButtonBackgrounds()
        NB.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func Dpressed(_ sender: UIButton) {
        score = prevScore + 2
        clearAllButtonBackgrounds()
        DB.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func SDpressed(_ sender: UIButton) {
        score = prevScore + 1
        clearAllButtonBackgrounds()
        SDB.backgroundColor = UIColor.lightGray
    }
    
    //stores the data to the database
    func StoreToDB(toSave: Int){
        //User should be logged in with reference created
        
        // Add a new document with a generated id.
                
        var ref: DocumentReference? = nil
        ref = Services.db.collection("users").document(Services.userRef).collection("Mood").addDocument(data: [
            "Date": Timestamp(date: Date()),
            "Score": toSave
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    // MARK - Changes storyboard and view controller to the home screen
    // Input: None
    // Output:
    //      1. Storyboard changes to HomeScreen and displays first view on the storyboard
    func GoToHome(){
        let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        if(self.score != self.prevScore){
            let toStore = self.score / 5
            StoreToDB(toSave: toStore)
            GoToHome()
        }
        
    }
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
          performSegue(withIdentifier: "Q5ToQ4", sender: self)
    }
    

}
