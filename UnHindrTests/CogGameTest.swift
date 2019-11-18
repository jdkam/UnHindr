//
//  CogGameTest.swift
//  UnHindrTests
//
//  Created by Jordan Kam on 2019-11-17.
//  Copyright © 2019 Sigma. All rights reserved.
//

import XCTest
@testable import UnHindr
import FirebaseAuth
import Firebase


class CogGameTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testCardGenerationPopulated() {
        
        let model = CardModel()
        var cardArray = [Card]()
        
        cardArray = model.getCards()
        
        if cardArray.count <= 0 {
            XCTFail("Generated card array is empty")
        }
    }
    
    
    
    func testCardImageGenerated() {
        let model = CardModel()
        var cardArray = [Card]()
        var card:Card!
        card = Card()
        
        cardArray = [Card]()
        cardArray = model.getCards()
        for card in cardArray{
    
            if card.imageName == "" {
                XCTFail("Image not assigned to card")
            }
        }
        
    }
    
    func testSoundManager() {
        let soundFilename = "cardflip"
        
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil
        else {
            XCTFail("Couldnt find sound file in the bundle")
            return
        }
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
