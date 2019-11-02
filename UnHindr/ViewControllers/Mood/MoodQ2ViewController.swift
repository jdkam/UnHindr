//
//  MoodQ2ViewController.swift
//  UnHindr
//
//  Created by Sina Ahmadian Behrouz on 11/1/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit

class MoodQ2ViewController: UIViewController {
    var score = 0
    var prevScore = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.score = self.prevScore
    }
    
    @IBOutlet weak var SAgree: UIButton!
    @IBOutlet weak var AgreeB: UIButton!
    @IBOutlet weak var NB: UIButton!
    @IBOutlet weak var DB: UIButton!
    @IBOutlet weak var SDB: UIButton!
    
    
    func clearAllButtonBackgrounds(){
        SAgree.backgroundColor = UIColor.white
        AgreeB.backgroundColor = UIColor.white
        NB.backgroundColor = UIColor.white
        DB.backgroundColor = UIColor.white
        SDB.backgroundColor = UIColor.white
    }
    
    @IBAction func SApressed(_ sender: UIButton) {
        score = prevScore + 5
        clearAllButtonBackgrounds()
        SAgree.backgroundColor = UIColor.lightGray
    }
    @IBAction func Agree(_ sender: UIButton) {
        score = prevScore + 4
        clearAllButtonBackgrounds()
        AgreeB.backgroundColor = UIColor.lightGray
    }
    @IBAction func Neutral(_ sender: UIButton) {
        score = prevScore + 3
        clearAllButtonBackgrounds()
        NB.backgroundColor = UIColor.lightGray
    }
    @IBAction func Disagree(_ sender: UIButton) {
        score = prevScore + 2
        clearAllButtonBackgrounds()
        DB.backgroundColor = UIColor.lightGray
    }
    @IBAction func SA(_ sender: Any) {
        score = prevScore + 1
        clearAllButtonBackgrounds()
        SDB.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        if(self.score != prevScore){
            performSegue(withIdentifier: "Q2ToQ3", sender: self)
        }
    }
    @IBAction func BackButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Q2ToQ1", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Q2ToQ3"){
            let vc = segue.destination as! MoodQ3ViewController
            vc.prevScore = self.score
        }
    }

}
