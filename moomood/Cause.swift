//
//  Cause.swift
//  moomood
//
//  Created by USMAC on 12/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import Foundation

class Cause: NSObject, NSCoding {
    var type: String
    
    init(type: String){
        self.type = type
    }
    
    struct CauseKey {
        static let type = "type"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: CauseKey.type)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let type = aDecoder.decodeObject(forKey: CauseKey.type) as? String
        self.init(type: type!)
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("causes")
}
