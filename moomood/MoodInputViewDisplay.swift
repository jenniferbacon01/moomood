import Foundation
import UIKit

class MoodInputViewDisplay: UIView {

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

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
