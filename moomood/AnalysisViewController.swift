//
//  AnalysisViewController.swift
//  moomood
//
//  Created by Rolando Sorbelli on 17/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit
import RealmSwift

class AnalysisViewController: UIViewController {

    @IBOutlet weak var happyOverviewMessage: UILabel!
    var happyMessage: String = ""
    func setUpHappyOverview (){
        let realm = try! Realm()
        let moods = realm.objects(Mood.self)
        print(moods)
        for i in (0..<moods.count){
            if moods[i].rating > 3 {
                happyMessage.append(moods[i].moodDescription)
            }
        }
        happyOverviewMessage.text = happyMessage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHappyOverview()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
