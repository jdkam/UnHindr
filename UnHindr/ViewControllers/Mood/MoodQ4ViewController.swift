//
//  MoodQ4ViewController.swift
//  UnHindr
//
//  Created by Sina Ahmadian Behrouz on 11/1/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit

class MoodQ4ViewController: UIViewController {
    var score = 0
    var prevScore = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.score = self.prevScore
        clearAllButtonBackgrounds()
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
    
    @IBAction func SATapped(_ sender: UIButton) {
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
    
    
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        if(self.score != self.prevScore){
            performSegue(withIdentifier: "Q4ToQ5", sender: self)

        }
    }
    
    @IBAction func BackButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Q4ToQ3", sender: self)

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Q4ToQ5"){
            let vc = segue.destination as! MoodQ5ViewController
            vc.prevScore = self.score
        }
    }
}
