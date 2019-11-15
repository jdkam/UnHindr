//
//  CardCollectionViewCell.swift
//  UnHindr
//
//  Created by Jordan Kam on 11/12/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card){
        
        //keeps tracks of the card that gets passed in
        self.card = card
        
        frontImageView.image = UIImage(named: card.imageName)
        
        //determine if the card is in a flipped up state or flipped down state
        if card.isFlipped == true {
            //make sure frontimageview is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else
        {
            //make sure the backImageview is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
        
    }
    
    //flips from back image view to front image view
    func flip() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        
        UIView.transition(from: frontImageView, to: backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
    }
}

