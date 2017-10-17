//
//  FirstViewController.swift
//  moomood
//
//  Created by Jennifer Bacon on 11/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var moods: Results<MoodDB>!
//    var moodsWithDesc: [MoodDB] = []

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadData()
        return moods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadData()
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = String(describing: moods[indexPath.row].date + String(describing:moods[indexPath.row].moodDescription))
        return cell
    }
    
    func loadData(){
        let realm = try! Realm()
        moods = realm.objects(MoodDB.self)
    }
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.delete {
//
//            moods.remove(at: indexPath.row)
//
//            table.reloadData()
//
//            NSKeyedArchiver.archiveRootObject(moods, toFile: Mood.ArchiveURL.path)
//
//        }
//    }
    
    
    
    
    @IBOutlet weak var table: UITableView!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        print(moods)
        
        table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func test(_ sender: Any) {
        print(moods)
    }
    

    
}



