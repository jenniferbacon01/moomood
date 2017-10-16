//
//  ShowMediaViewController.swift
//  moomood
//
//  Created by Elizabeth Chan on 16/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit

class ShowMediaViewController: UIViewController {
    var image: UIImage? = nil
    var titreText: String!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titre: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //titre.text = titreText
        
        if image != nil {
            imageView.image = image
        } else {
            print("image not found")
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
}
