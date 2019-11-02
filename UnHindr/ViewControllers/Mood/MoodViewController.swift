//
//  MoodViewController.swift
//  UnHindr
//
//  Created by Sina Ahmadian Behrouz on 11/1/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit

class MoodViewController: UIViewController {
    var score = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAllButtonBackgrounds()
    }

    
    @IBOutlet weak var StronglyAgree: UIButton!
    @IBOutlet weak var AgreeButton: UIButton!
    @IBOutlet weak var NuetralButton: UIButton!
    @IBOutlet weak var DisagreeButton: UIButton!
    @IBOutlet weak var StronglyDisagreeButton: UIButton!
    
    
    // MARK: - Visual effects on the choice buttons
    // Backend Function
    // Input: None
    // Output:
    //      1.The choice buttons now contain a white background
    func clearAllButtonBackgrounds(){
        StronglyAgree.backgroundColor = UIColor.white
        AgreeButton.backgroundColor = UIColor.white
        NuetralButton.backgroundColor = UIColor.white
        DisagreeButton.backgroundColor = UIColor.white
        StronglyDisagreeButton.backgroundColor = UIColor.white
    }
    
    @IBAction func SAgreeButtonTapped(_ sender: UIButton) {
        score = 5
        clearAllButtonBackgrounds()
        StronglyAgree.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func AgreeButtonTapped(_ sender: UIButton) {
        score = 4
        clearAllButtonBackgrounds()
        AgreeButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func NuetralButtonTapped(_ sender: UIButton) {
        score = 3
        clearAllButtonBackgrounds()
        NuetralButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func disagreeButtonTapped(_ sender: UIButton) {
        score = 2
        clearAllButtonBackgrounds()
        DisagreeButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func SDisagreeButtonTapped(_ sender: UIButton) {
        score = 1
        clearAllButtonBackgrounds()
        StronglyDisagreeButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        if(self.score != 0){
            performSegue(withIdentifier: "Q1ToQ2", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Q1ToQ2"){
            let vc = segue.destination as! MoodQ2ViewController
            vc.prevScore = self.score
        }
    }
}
