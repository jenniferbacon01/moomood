import Foundation
import UIKit

class MoodInputViewDisplay {

    func displayChosenMoodMessage(number: Int, chosenMoodMessage: UILabel) {
        let messageString = "you chose "
        chosenMoodMessage.text = (messageString + String(number))
    }
    
    func hideButtons(buttons: [UIButton]){
        for i in (0..<buttons.count) {
            buttons[i].isHidden = true
        }
    }
    
    func showButtons(buttons: [UIButton]){
        for i in (0..<buttons.count) {
            buttons[i].isHidden = false
        }
    }
    
    func formatButton(button: UIButton, colorOne: UIColor, colorTwo: UIColor){
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setGradientBackground(colorOne: colorOne, colorTwo: colorTwo)
    }
    
    
}
