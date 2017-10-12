//
//  SecondViewController.swift
//  moomood
//
//  Created by Jennifer Bacon on 11/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var whyMessage: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    @IBAction func button1(_ sender: Any) {
        buttonMethod(number:1)
    }
    
    @IBAction func button2(_ sender: Any) {
        buttonMethod(number:2)
    }
    
    @IBAction func button3(_ sender: UIButton) {
        buttonMethod(number:3)
    }
    @IBAction func button4(_ sender: UIButton) {
        buttonMethod(number:4)
    }
    @IBAction func button5(_ sender: UIButton) {
        buttonMethod(number:5)
    }
    func buttonMethod(number: Int) {
        messageDisplay(number: number)
        whyMessage.isHidden = false
        hideNumberButtons()
        showCauseButtons()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat="dd MMM"
        let result = formatter.string(from: date)

        
        let mood = Mood(date:result,rating: number)
        let moodsObject = NSKeyedUnarchiver.unarchiveObject(withFile: Mood.ArchiveURL.path)
        
        var moods: [Mood]
        
        if let tempmoods = moodsObject as? [Mood] {
            moods = tempmoods
            moods.append(mood)
        } else {
            moods = [mood]
            
        }
        
        NSKeyedArchiver.archiveRootObject(moods, toFile: Mood.ArchiveURL.path)
    }
    
    func messageDisplay(number: Int) {
        let messageString = "you chose "
        message.text = (messageString + String(number))
    }
    
    
    
    
    func hideNumberButtons(){
        button1.isHidden = true
        button2.isHidden = true
        button3.isHidden = true
        button4.isHidden = true
        button5.isHidden = true
    }

    func showNumberButtons(){
        button1.isHidden = false
        button2.isHidden = false
        button3.isHidden = false
        button4.isHidden = false
        button5.isHidden = false
    }

    @IBOutlet weak var workButton: UIButton!
    @IBOutlet weak var familyButton: UIButton!
    @IBOutlet weak var partnerButton: UIButton!
    @IBOutlet weak var healthButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var financesButton: UIButton!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var preferNotToSayButton: UIButton!
    
    func showCauseButtons(){
        workButton.isHidden = false
        familyButton.isHidden = false
        partnerButton.isHidden = false
        healthButton.isHidden = false
        homeButton.isHidden = false
        financesButton.isHidden = false
        weatherButton.isHidden = false
        otherButton.isHidden = false
        preferNotToSayButton.isHidden = false
    }

    func hideCauseButtons(){
        workButton.isHidden = true
        familyButton.isHidden = true
        partnerButton.isHidden = true
        healthButton.isHidden = true
        homeButton.isHidden = true
        financesButton.isHidden = true
        weatherButton.isHidden = true
        otherButton.isHidden = true
        preferNotToSayButton.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        message.text = nil
        whyMessage.isHidden = true
        hideCauseButtons()
        showNumberButtons()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    private func saveMoods() {
//        
//        NSKeyedArchiver.archiveRootObject(moods, toFile: Mood.ArchiveURL.path)
//        
//    }
    
//    private func loadMoods() -> [Mood]? {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: Mood.ArchiveURL.path) as? [Mood]
//    }
    
    
}
