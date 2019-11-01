//
//  MoodViewController.swift
//  UnHindr
//
//  Created by Sina Ahmadian Behrouz on 11/1/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit

class MoodViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    var score = 0
    
    @IBOutlet weak var StronglyAgree: UIButton!
    @IBOutlet weak var AgreeButton: UIButton!
    @IBOutlet weak var NuetralButton: UIButton!
    @IBOutlet weak var DisagreeButton: UIButton!
    @IBOutlet weak var StronglyDisagreeButton: UIButton!
    
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
        StronglyAgree.backgroundColor = UIColor.blue
        print(score)
    }
    
    @IBAction func AgreeButtonTapped(_ sender: UIButton) {
        score = 4
        clearAllButtonBackgrounds()
        AgreeButton.backgroundColor = UIColor.blue
        print(score)
    }
    
    @IBAction func NuetralButtonTapped(_ sender: UIButton) {
        score = 3
        clearAllButtonBackgrounds()
        NuetralButton.backgroundColor = UIColor.blue
        print(score)
    }
    
    @IBAction func disagreeButtonTapped(_ sender: UIButton) {
        score = 2
        clearAllButtonBackgrounds()
        DisagreeButton.backgroundColor = UIColor.blue
        print(score)
    }
    
    @IBAction func SDisagreeButtonTapped(_ sender: UIButton) {
        score = 1
        clearAllButtonBackgrounds()
        StronglyDisagreeButton.backgroundColor = UIColor.blue
        print(score)
    }
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        print("Next is tapped")
    }
}
