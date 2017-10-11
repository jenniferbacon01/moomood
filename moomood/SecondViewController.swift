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
        let moodsObject = UserDefaults.standard.object(forKey: "moods")
        
        var moods: [String]
        
        if let tempmoods = moodsObject as? [String] {
            moods = tempmoods
            moods.append(String(number))
        } else {
            moods = [String(number)]
            
        }
        
        UserDefaults.standard.set(moods, forKey: "moods")
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
    
    
}
