//
//  SecondViewController.swift
//  moomood
//
//  Created by Jennifer Bacon on 11/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit
import RealmSwift

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


class SecondViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var chosenMoodMessage: UILabel!
    @IBOutlet weak var whyMessage: UILabel!
//    var mood: Mood?
    var number: Int?
    
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
        number = 1
        buttonMethod(number: number!)
    }
    
    @IBAction func button2(_ sender: Any) {
        number = 2
        buttonMethod(number: number!)
    }
    
    @IBAction func button3(_ sender: UIButton) {
        number = 3
        buttonMethod(number: number!)
    }
    @IBAction func button4(_ sender: UIButton) {
        number = 4
        buttonMethod(number: number!)
    }
    @IBAction func button5(_ sender: UIButton) {
        number = 5
        buttonMethod(number: number!)
    }
    func buttonMethod(number: Int) {
        displayChosenMoodMessage(number: number)
        whyMessage.isHidden = false
        hideNumberButtons()
        showCauseButtons()
    }
    
    func displayChosenMoodMessage(number: Int) {
        let messageString = "you chose "
        chosenMoodMessage.text = (messageString + String(number))
    }
    
    @IBAction func workButton(_ sender: Any) {
        causeButtonMethod(cause: "Work")
    }
    
    @IBAction func familyButton(_ sender: Any) {
        causeButtonMethod(cause: "Family")
    }
    @IBAction func partnerButton(_ sender: Any) {
        causeButtonMethod(cause: "Partner")
    }
    
    @IBAction func healthButton(_ sender: Any) {
        causeButtonMethod(cause: "Health")
    }
    
    @IBAction func homeButton(_ sender: Any) {
        causeButtonMethod(cause: "Home")
    }
    
    @IBAction func financesButton(_ sender: Any) {
        causeButtonMethod(cause: "Finances")
        
    }
    
    @IBAction func weatherButton(_ sender: Any) {
        causeButtonMethod(cause: "Weather")
    }
    @IBAction func otherButton(_ sender: Any) {
        causeButtonMethod(cause: "Other")
    }
    @IBAction func ratherNotSayButton(_ sender: Any) {
        causeButtonMethod(cause: "I'd rather not say")
    }
    func causeButtonMethod(cause: String) {
        let unformattedDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: unformattedDate)
//        mood = Mood(date:formattedDate,rating: number!, cause: cause)
//        let moodsObject = NSKeyedUnarchiver.unarchiveObject(withFile: Mood.ArchiveURL.path)
//        var moods: [Mood]
//        if let tempmoods = moodsObject as? [Mood] {
//            moods = tempmoods
//            moods.append(mood!)
//        } else {
//            moods = [mood!]
//        }
//        print(mood!.cause)
//        NSKeyedArchiver.archiveRootObject(moods, toFile: Mood.ArchiveURL.path)
        
        addMood(formattedDate, rating: number!, cause: cause, moodDescription: "", others: "")
        
        performSegue(withIdentifier: "goToChat", sender: nil)
    }
    
    
    
    
    // define a new function to save data to Realm
    func addMood(_ date: String, rating: Int, cause: String, moodDescription: String, others: String) {
        // class Message
        let mood = Mood()
        mood.date = date
        mood.rating = rating
        mood.cause = cause
        mood.moodDescription = moodDescription
        mood.others = others
        
        // write to Realm
        let realm = try! Realm()
        try! realm.write {
            realm.add(mood)
        }
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
        chosenMoodMessage.text = nil
        whyMessage.isHidden = true
        hideCauseButtons()
        showNumberButtons()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layer.cornerRadius = 10
        button1.layer.masksToBounds = true
        button1.setGradientBackground(colorOne: UIColor.black, colorTwo: UIColor.purple)
        
        button2.layer.cornerRadius = 10
        button2.layer.masksToBounds = true
        button2.setGradientBackground(colorOne: UIColor.darkGray, colorTwo: UIColor.purple)
        
        button3.layer.cornerRadius = 10
        button3.layer.masksToBounds = true
        button3.setGradientBackground(colorOne: UIColor.gray, colorTwo: UIColor.purple)
        
        button4.layer.cornerRadius = 10
        button4.layer.masksToBounds = true
        button4.setGradientBackground(colorOne: UIColor.lightGray, colorTwo: UIColor.purple)
        
        button5.layer.cornerRadius = 10
        button5.layer.masksToBounds = true
        button5.setGradientBackground(colorOne: UIColor.white, colorTwo: UIColor.purple)
        
        

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
