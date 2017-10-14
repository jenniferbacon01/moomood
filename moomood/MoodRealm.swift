//
//  MoodRealm.swift
//  moomood
//
//  Created by Elizabeth Chan on 14/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import Foundation
import RealmSwift

class MoodRealm: Object{
    
    @objc dynamic var rating = 0
    @objc dynamic var date = ""
    @objc dynamic var cause = ""
    
    
}
