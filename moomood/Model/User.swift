//
//  User.swift
//  moomood
//
//  Created by USMAC on 17/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit
import RealmSwift


class User {
    private(set) public var id: String
    private(set) public var name: String
    private(set) public var password: String
    
    init(id: String, name: String, password: String) {
        self.id = id
        self.name = name
        self.password = password
    }
}
