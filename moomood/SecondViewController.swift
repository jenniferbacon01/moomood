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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
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
