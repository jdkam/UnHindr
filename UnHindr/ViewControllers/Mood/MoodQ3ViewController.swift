//
//  MoodQ3ViewController.swift
//  UnHindr
//
//  Created by Sina Ahmadian Behrouz on 11/1/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit

class MoodQ3ViewController: UIViewController {
    var score = 0
    var prevScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.score = self.prevScore
    }
    @IBOutlet weak var SAB: UIButton!
    @IBOutlet weak var AB: UIButton!
    @IBOutlet weak var NB: UIButton!
    @IBOutlet weak var DB: UIButton!
    @IBOutlet weak var SDB: UIButton!
    
    func clearAllButtonBackgrounds(){
        SAB.backgroundColor = UIColor.white
        AB.backgroundColor = UIColor.white
        NB.backgroundColor = UIColor.white
        DB.backgroundColor = UIColor.white
        SDB.backgroundColor = UIColor.white
    }
    
    @IBAction func SApressed(_ sender: UIButton) {
        score = prevScore + 5
        clearAllButtonBackgrounds()
        SAB.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func APressed(_ sender: UIButton) {
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
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "Q3ToQ2", sender: self)
    }
    
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        if(self.score != self.prevScore){
            performSegue(withIdentifier: "Q3ToQ4", sender: self)

        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Q3ToQ4"){
            let vc = segue.destination as! MoodQ4ViewController
            vc.prevScore = self.score
        }
    }
}
