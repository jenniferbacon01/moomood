//
//  RealmSwiftObj.swift
//  moomood
//
//  Created by Elizabeth Chan on 13/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import Foundation
import RealmSwift

class Message: Object{
    
    @objc dynamic var senderName = ""
    @objc dynamic var senderID = ""
    @objc dynamic var senderMessage = ""

 
}

//    @objc dynamic var date = Date()
