//
//  FirstViewController.swift
//  moomood
//
//  Created by Jennifer Bacon on 11/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var moods: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = String(describing: moods[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            moods.remove(at: indexPath.row)
            
            table.reloadData()
            
            UserDefaults.standard.set(moods, forKey: "moods")
            
        }
    }
    
    
    
    
    @IBOutlet weak var table: UITableView!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        let moodsObject = UserDefaults.standard.object(forKey: "moods")
        
        if let tempmoods = moodsObject as? [String] {
            moods = tempmoods
        }
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



