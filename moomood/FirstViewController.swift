//
//  FirstViewController.swift
//  moomood
//
//  Created by Jennifer Bacon on 11/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var moods: [Mood] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moods.count
    }
    
//    func tableView(_ tableView: UITableView, numberOfColumnsInSection section: Int) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = String(describing: moods[indexPath.row].date + String(describing:moods[indexPath.row].rating))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            moods.remove(at: indexPath.row)
            
            table.reloadData()
            
            NSKeyedArchiver.archiveRootObject(moods, toFile: Mood.ArchiveURL.path)
            
        }
    }
    
    
    
    
    @IBOutlet weak var table: UITableView!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        let moodsObject = NSKeyedUnarchiver.unarchiveObject(withFile: Mood.ArchiveURL.path)
        
        if let tempmoods = moodsObject as? [Mood] {
            moods = tempmoods
        }
        
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



