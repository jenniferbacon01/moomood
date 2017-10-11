//
//  Mood.swift
//  moomood
//
//  Created by Jennifer Bacon on 11/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import Foundation

class Mood: NSObject, NSCoding {
    var date: String
    var rating: Int
    
    init(date: String, rating: Int){
        self.date = date
        self.rating = rating
    }
    
    struct MoodKey {
        static let date = "date"
        static let rating = "rating"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: MoodKey.date)
        aCoder.encode(rating, forKey: MoodKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: MoodKey.date) as? String
        let rating = aDecoder.decodeInteger(forKey: MoodKey.rating)
        self.init(date: date!, rating: rating)

    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("moods")
}
