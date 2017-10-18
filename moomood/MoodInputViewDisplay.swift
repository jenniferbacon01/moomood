//
//  MoodInputViewDisplay.swift
//  moomood
//
//  Created by Jennifer Bacon on 18/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import Foundation
import UIKit

class MoodInputViewDisplay {

    func displayChosenMoodMessage(number: Int, chosenMoodMessage: UILabel) {
        let messageString = "you chose "
        chosenMoodMessage.text = (messageString + String(number))
    }
    
    func hideNumberButtons(numberButtons: [UIButton]){
        for i in (0..<numberButtons.count) {
            numberButtons[i].isHidden = true
        }
    }
    
    func showNumberButtons(numberButtons: [UIButton]){
        for i in (0..<numberButtons.count) {
            numberButtons[i].isHidden = false
        }
    }
    
    func showCauseButtons(causeButtons: [UIButton]) {
        for i in (0..<causeButtons.count) {
            causeButtons[i].isHidden = false
        }
    }
    
    
    func hideCauseButtons(causeButtons: [UIButton]){
        for i in (0..<causeButtons.count) {
            causeButtons[i].isHidden = true
        }
    }
    
    
}
