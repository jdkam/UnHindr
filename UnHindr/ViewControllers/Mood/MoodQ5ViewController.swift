//
//  MoodQ5ViewController.swift
//  UnHindr
//
//  Created by Sina Ahmadian Behrouz on 11/1/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit

class MoodQ5ViewController: UIViewController {
    var score = 0
    var prevScore = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.score = self.prevScore
    }
    
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
        
    }
    
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        if(self.score != self.prevScore){
            var toStore = self.score / 5
            StoreToDB(toSave: toStore)
        }
        
    }
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
          performSegue(withIdentifier: "Q5ToQ4", sender: self)
    }
    

}
