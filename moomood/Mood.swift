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
    var cause: String
    
    init(date: String, rating: Int, cause: String){
        self.date = date
        self.rating = rating
        self.cause = cause
    }
    
    
    struct MoodKey {
        static let date = "date"
        static let rating = "rating"
        static let cause = "cause"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: MoodKey.date)
        aCoder.encode(rating, forKey: MoodKey.rating)
        aCoder.encode(cause, forKey: MoodKey.cause)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: MoodKey.date) as? String
        let rating = aDecoder.decodeInteger(forKey: MoodKey.rating)
        let cause = aDecoder.decodeObject(forKey: MoodKey.cause) as? String
        self.init(date: date!, rating: rating, cause: cause!)

    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("moods")
}
