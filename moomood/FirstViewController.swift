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
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var moods: Results<Mood>!
//    var moodsWithDesc: [MoodDB] = []

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadData()
        return moods.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Date                   Rating            Reason"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadData()
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = String(describing: moods[indexPath.row].date + "                 " + String(describing:moods[indexPath.row].rating) + "/5" + "                     " + String(describing:moods[indexPath.row].cause.capitalized))
        cell.textLabel?.font = UIFont(name: "Avenir Next Ultra Light", size: 17)
        cell.textLabel?.textColor = UIColor.purple
        return cell
    }
    
    func loadData(){
        let realm = try! Realm()
        moods = realm.objects(Mood.self)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {

//            moods.remove(at: indexPath.row)

            table.reloadData()
            loadData()

//            NSKeyedArchiver.archiveRootObject(moods, toFile: Mood.ArchiveURL.path)

        }
    }
    
    
    
    
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("HELLO")
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
    
}



