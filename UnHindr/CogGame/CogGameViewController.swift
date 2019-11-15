//
//  CogGameViewController.swift
//  UnHindr
//
//  Created by Jordan Kam on 11/12/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class CogGameViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var timer : Timer?
    var seconds = 30
    
    
    var firstFlippedCardIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call getCards method of the card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //create timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
    }
    
    //MARK: Timer Methods
    
    @objc func timerElapsed(){
        
        seconds -= 1
        
        //convert to seconds
        //let seconds = String(format: "", seconds)
        
        //set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        
    }
   
    //sets the number of items on a row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/4.0
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    //sets spacing for items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    //sets spacing for items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return -10
    }
    
    //sets spacing for items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // MARK: - UICollectionView Protocol Methods
    
    //ask delegate how many items need to be displayed
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    //collectionView asks dataSource (viewController) for new data to display - for each individual cell to be displayed
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //get a cardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        //set the card for that cell
        cell.setCard(card)
        
        return cell
    }
    
    //when a user taps on a cell in the grid
    //protocol method is part of UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //get cell that user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //get card that user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false
        {
            //flip the card
            cell.flip()
            
            //set status of the card
            card.isFlipped = true
            
            //determine if its the first card or second card thats flipped over
            if firstFlippedCardIndex == nil {
                
                //this is the first card being flipped
                firstFlippedCardIndex = indexPath
                
            }
            else
            {
                //this is the second card being flipped
                
                //TODO: performs the matching logic
                checkForMatches(indexPath)
            }
        }
        else
        {
          
        }
        
        
       
    
    } //end of the didSelectItemAt method
    
    //MARK: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        
        
        //get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //get the cards for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            //its a match
            
            
            //set status of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
        }
        else
        {
            
            //its not a match
            
            //set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
            
        }
        
        //tell the collectionView to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        
        //reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
    }
    
    

    
} //end of viewController class
